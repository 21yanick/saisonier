import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import PocketBase from 'pocketbase';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3001;
const POCKETBASE_URL = process.env.POCKETBASE_URL || 'http://localhost:8091';
const GEMINI_API_KEY = process.env.GEMINI_API_KEY;
const GEMINI_MODEL = process.env.GEMINI_MODEL || 'gemini-2.5-flash-lite';

if (!GEMINI_API_KEY) {
  console.error('GEMINI_API_KEY environment variable is required');
  process.exit(1);
}

app.use(cors());
app.use(express.json());

// PocketBase client for auth verification
const pb = new PocketBase(POCKETBASE_URL);

// Decode JWT to get user ID (without verification - PB SDK handles validity)
function decodeJwt(token) {
  try {
    const parts = token.split('.');
    if (parts.length !== 3) return null;
    const payload = JSON.parse(Buffer.from(parts[1], 'base64').toString());
    return payload;
  } catch (e) {
    return null;
  }
}

// Auth middleware - verify PocketBase token
async function authMiddleware(req, res, next) {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith('Bearer ')) {
    return res.status(401).json({ error: 'Unauthorized', message: 'No Bearer token provided' });
  }

  const token = authHeader.substring(7);

  try {
    // Decode JWT to get user ID
    const payload = decodeJwt(token);
    if (!payload || !payload.id) {
      return res.status(401).json({ error: 'Invalid token', message: 'Cannot decode token' });
    }

    // Verify token is not expired
    const now = Math.floor(Date.now() / 1000);
    if (payload.exp && payload.exp < now) {
      return res.status(401).json({ error: 'Token expired', message: 'Please login again' });
    }

    console.log('Auth OK - User:', payload.id);
    req.userId = payload.id;
    req.token = token;
    next();
  } catch (e) {
    console.log('Auth error:', e.message);
    return res.status(401).json({ error: 'Invalid token', message: e.message });
  }
}

// Premium check middleware
async function premiumMiddleware(req, res, next) {
  try {
    console.log('Checking premium for user:', req.userId);
    // Use user's token to respect API rules
    pb.authStore.save(req.token);
    const aiProfiles = await pb.collection('ai_profiles').getList(1, 1, {
      filter: `user_id = "${req.userId}"`,
    });
    console.log('AI Profiles found:', aiProfiles.items.length);
    if (aiProfiles.items.length === 0) {
      console.log('No premium - returning 403');
      return res.status(403).json({ error: 'Premium required' });
    }
    req.aiProfile = aiProfiles.items[0];
    console.log('Premium OK');
    next();
  } catch (e) {
    console.log('Premium check error:', e.message);
    return res.status(403).json({ error: 'Premium required' });
  }
}

// Get user profile for context
async function getUserProfile(userId) {
  try {
    const profiles = await pb.collection('user_profiles').getList(1, 1, {
      filter: `user_id = "${userId}"`,
    });
    return profiles.items[0] || null;
  } catch (e) {
    return null;
  }
}

// Call Gemini API
async function callGemini(prompt, options = {}) {
  const response = await fetch(
    `https://generativelanguage.googleapis.com/v1beta/models/${GEMINI_MODEL}:generateContent?key=${GEMINI_API_KEY}`,
    {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        contents: [{ parts: [{ text: prompt }] }],
        generationConfig: {
          temperature: options.temperature || 0.7,
          maxOutputTokens: options.maxOutputTokens || 8192,
          responseMimeType: 'application/json',
        },
      }),
    }
  );

  const data = await response.json();

  if (data.error) {
    throw new Error(data.error.message);
  }

  const text = data.candidates?.[0]?.content?.parts?.[0]?.text;
  if (!text) {
    throw new Error('No response from Gemini');
  }

  console.log('Raw Gemini response:', text.substring(0, 500) + '...');

  // Clean up response - sometimes Gemini adds markdown code blocks
  let cleanText = text.trim();
  if (cleanText.startsWith('```json')) {
    cleanText = cleanText.slice(7);
  } else if (cleanText.startsWith('```')) {
    cleanText = cleanText.slice(3);
  }
  if (cleanText.endsWith('```')) {
    cleanText = cleanText.slice(0, -3);
  }
  cleanText = cleanText.trim();

  let result;
  try {
    result = JSON.parse(cleanText);
  } catch (parseError) {
    console.error('JSON parse error. Raw text:', text);
    throw new Error(`Invalid JSON from Gemini: ${parseError.message}`);
  }
  // Gemini sometimes returns an array with a single object - extract it
  if (Array.isArray(result) && result.length > 0) {
    result = result[0];
  }
  return {
    result,
    usage: data.usageMetadata,
  };
}

// Log AI request
async function logAIRequest(userId, requestType, tokensUsed, success, errorMessage = null) {
  try {
    await pb.collection('ai_requests').create({
      user_id: userId,
      request_type: requestType,
      tokens_used: tokensUsed || 0,
      success: success,
      error_message: errorMessage,
    });
  } catch (e) {
    console.error('Failed to log AI request:', e);
  }
}

// Get seasonal vegetables for current month from database
async function getSeasonalVegetables() {
  try {
    const currentMonth = new Date().getMonth() + 1; // 1-12
    const vegetables = await pb.collection('vegetables').getFullList({
      filter: `months ~ "${currentMonth}"`,
      sort: 'name',
    });
    return vegetables.map(v => v.name);
  } catch (e) {
    console.error('Failed to get seasonal vegetables:', e);
    // Fallback für Dezember
    return ['Lauch', 'Wirz', 'Rosenkohl', 'Schwarzwurzel', 'Randen', 'Karotten', 'Knollensellerie', 'Kürbis', 'Chinakohl', 'Chicorée'];
  }
}

// Get month name in German
function getMonthName(month) {
  const months = ['', 'Januar', 'Februar', 'März', 'April', 'Mai', 'Juni', 'Juli', 'August', 'September', 'Oktober', 'November', 'Dezember'];
  return months[month] || '';
}

// Map style enum to description
function getStyleDescription(style) {
  const styles = {
    comfort: 'Comfort Food - herzhaft, wärmend, sättigend',
    quick: 'Schnell & Einfach - max. 30 Minuten, wenig Schritte',
    healthy: 'Gesund & Leicht - kalorienarm, viel Gemüse',
    festive: 'Festlich - für besondere Anlässe, beeindruckend',
    onePot: 'One-Pot - alles in einem Topf/Pfanne, wenig Abwasch',
    budget: 'Budget-freundlich - günstige Zutaten',
  };
  return styles[style] || styles.comfort;
}

// Map inspiration to additional instructions
function getInspirationInstructions(inspiration) {
  const instructions = {
    surprise: 'Überrasche den User mit einem kreativen, unerwarteten Rezept!',
    quick: 'WICHTIG: Maximale Gesamtzeit 20 Minuten!',
    onePot: 'WICHTIG: Alles in einem Topf oder einer Pfanne zubereiten!',
    kidFriendly: 'WICHTIG: Kinderfreundlich - milde Gewürze, keine komplizierten Texturen, ansprechende Präsentation!',
    forGuests: 'WICHTIG: Dieses Gericht ist für Gäste - sollte beeindruckend aussehen!',
  };
  return instructions[inspiration] || '';
}

// Build recipe generation prompt (v2 - extended)
function buildRecipePrompt(request, userProfile, aiProfile, seasonalVegetablesFromDB) {
  // User Profile data
  const allergens = userProfile?.allergens?.join(', ') || 'keine';
  const diet = userProfile?.diet || 'omnivore';
  const dislikes = userProfile?.dislikes?.join(', ') || 'keine';
  const skill = userProfile?.skill || 'beginner';
  const maxTime = request.force_quick ? 30 : (userProfile?.max_cooking_time_min || 60);
  const householdSize = userProfile?.household_size || 2;
  const childrenCount = userProfile?.children_count || 0;

  // AI Profile data (with possible overrides from request)
  const cuisines = request.cuisine_override
    ? request.cuisine_override
    : (aiProfile?.cuisine_preferences?.join(', ') || 'alle');
  const flavors = aiProfile?.flavor_profile?.join(', ') || 'ausgewogen';
  const proteins = request.protein_override
    ? request.protein_override
    : (aiProfile?.protein_preferences?.join(', ') || 'alle');
  const budget = aiProfile?.budget_level || 'normal';
  const nutritionFocus = request.nutrition_override
    ? request.nutrition_override
    : (aiProfile?.nutrition_focus || 'balanced');
  const healthGoals = aiProfile?.health_goals?.join(', ') || 'keine besonderen';
  const equipment = aiProfile?.equipment?.join(', ') || 'Standard-Küche';
  const likes = aiProfile?.likes?.join(', ') || 'keine besonderen';

  // Learning context
  const rejected = aiProfile?.learning_context?.rejectedSuggestions?.join(', ') || 'nichts';
  const accepted = aiProfile?.learning_context?.acceptedSuggestions?.join(', ') || 'keine';

  // Request data
  const currentMonth = new Date().getMonth() + 1;
  const monthName = getMonthName(currentMonth);
  const seasonalList = seasonalVegetablesFromDB.join(', ');
  const selectedVegetables = request.seasonal_vegetables?.length > 0
    ? request.seasonal_vegetables.join(', ')
    : null;
  const styleDescription = getStyleDescription(request.style);
  const category = request.category || 'main';
  const freeFormRequest = request.free_form_request || '';
  const additionalIngredients = request.additional_ingredients || '';
  const inspirationInstructions = getInspirationInstructions(request.inspiration);

  // Diet overrides
  let dietOverride = '';
  if (request.force_vegan) {
    dietOverride = 'WICHTIG: Dieses Rezept MUSS vegan sein - keine tierischen Produkte!';
  } else if (request.force_vegetarian) {
    dietOverride = 'WICHTIG: Dieses Rezept MUSS vegetarisch sein - kein Fleisch oder Fisch!';
  }

  return `
Du bist ein Schweizer Koch-Experte. Erstelle ein Rezept basierend auf folgendem Kontext.

## STRIKTE REGELN (NIEMALS VERLETZEN)
- Allergene ABSOLUT VERMEIDEN: ${allergens}
- Basis-Ernährungsform: ${diet}
- Dislikes VERMEIDEN: ${dislikes}
- Abgelehnte Zutaten (User mochte nicht): ${rejected}
${dietOverride ? `- ${dietOverride}` : ''}
${request.force_quick ? '- MAXIMALE Gesamtzeit: 30 Minuten!' : ''}

## USER PROFIL
- Haushalt: ${householdSize} Personen${childrenCount > 0 ? ` (davon ${childrenCount} Kinder)` : ''}
- Kochskill: ${skill}
- Max. Kochzeit: ${maxTime} Minuten
- Verfügbares Equipment: ${equipment}

## PRÄFERENZEN
- Lieblings-Küchen: ${cuisines}
- Geschmacksprofil: ${flavors}
- Bevorzugte Proteine: ${proteins}
- Budget: ${budget}
- Ernährungs-Fokus: ${nutritionFocus}
- Gesundheitsziele: ${healthGoals}
- User mag besonders: ${likes}
- User hat positiv bewertet: ${accepted}

## SAISONALES GEMÜSE (${monthName}, Schweiz)
Aktuell verfügbar: ${seasonalList}
${selectedVegetables ? `User möchte speziell: ${selectedVegetables}` : 'User hat keine Präferenz - wähle passend zur Saison'}

## ANFRAGE
- Kategorie: ${category} (main=Hauptgericht, side=Beilage, soup=Suppe, salad=Salat, dessert=Dessert, snack=Snack)
- Stil: ${styleDescription}
- Zusätzliche Zutaten: ${additionalIngredients || 'keine angegeben'}
${freeFormRequest ? `- Spezieller Wunsch: "${freeFormRequest}"` : ''}
${inspirationInstructions ? `\n${inspirationInstructions}` : ''}

## WICHTIGE RICHTLINIEN
1. Das Rezept MUSS mindestens 1 saisonales Gemüse prominent verwenden
2. Respektiere ALLE Einschränkungen (Allergene, Diet, Dislikes)
3. Passe Schwierigkeit an den Kochskill an
4. Berücksichtige das Budget bei der Zutatenwahl
5. Bei Kindern im Haushalt: kindgerechte Varianten bevorzugen
6. Schweizer Begriffe verwenden (Rahm statt Sahne, Poulet statt Hähnchen)

## OUTPUT FORMAT (JSON)
{
  "title": "Rezeptname",
  "description": "Kurze Beschreibung (1-2 Sätze, appetitanregend)",
  "prepTimeMin": 15,
  "cookTimeMin": 25,
  "servings": ${householdSize},
  "difficulty": "easy|medium|hard",
  "category": "${category}",
  "ingredients": [
    {"item": "Lauch", "amount": "2", "unit": "Stangen", "note": "in Ringe geschnitten"}
  ],
  "steps": [
    "Schritt 1...",
    "Schritt 2..."
  ],
  "tags": ["saisonal", "vegetarisch", "schnell"],
  "isVegetarian": true,
  "isVegan": false,
  "mainVegetable": "Lauch",
  "tip": "Optional: Kurzer Profi-Tipp"
}

Antworte NUR mit dem JSON, ohne Markdown-Formatierung.
`;
}

// Build weekplan generation prompt
function buildWeekplanPrompt(request, userProfile, aiProfile) {
  const allergens = userProfile?.allergens?.join(', ') || 'keine';
  const diet = userProfile?.diet || 'omnivore';
  const dislikes = userProfile?.dislikes?.join(', ') || 'keine';
  const skill = userProfile?.skill || 'beginner';
  const maxTime = userProfile?.max_cooking_time_min || 60;
  const householdSize = userProfile?.household_size || 2;
  const childrenCount = userProfile?.children_count || 0;

  const cuisines = aiProfile?.cuisine_preferences?.join(', ') || 'alle';
  const flavors = aiProfile?.flavor_profile?.join(', ') || 'ausgewogen';
  const budget = aiProfile?.budget_level || 'normal';
  const mealPrepStyle = aiProfile?.meal_prep_style || 'mixed';
  const nutritionFocus = aiProfile?.nutrition_focus || 'balanced';
  const healthGoals = aiProfile?.health_goals?.join(', ') || 'keine besonderen';
  const equipment = aiProfile?.equipment?.join(', ') || 'Standard-Küche';
  const rejected = aiProfile?.learning_context?.rejectedSuggestions?.join(', ') || 'nichts';
  const topIngredients = aiProfile?.learning_context?.topIngredients?.join(', ') || 'keine Präferenz';

  const dayNames = ['', 'Mo', 'Di', 'Mi', 'Do', 'Fr', 'Sa', 'So'];
  const selectedDaysStr = request.selected_days?.map(d => dayNames[d]).join(', ') || 'Mo-Fr';

  // Get current week dates
  const today = new Date();
  const weekStart = new Date(today);
  weekStart.setDate(today.getDate() - today.getDay() + 1); // Monday

  return `
Du bist ein Schweizer Ernährungsexperte und Meal-Planner. Erstelle einen Wochenplan.

## STRIKTE REGELN (NIEMALS VERLETZEN)
- Allergene ABSOLUT VERMEIDEN: ${allergens}
- Ernährungsform STRIKT einhalten: ${diet}
- Dislikes VERMEIDEN: ${dislikes}
- NICHT vorschlagen: ${rejected}

## HAUSHALT
- Personen: ${householdSize}
- Kinder: ${childrenCount}
- Kochskill: ${skill}
- Max. Kochzeit pro Mahlzeit: ${maxTime} Minuten

## PRÄFERENZEN
- Lieblings-Küchen: ${cuisines}
- Geschmacksprofil: ${flavors}
- Budget: ${budget}
- Kochstil: ${mealPrepStyle}
- Ernährungs-Fokus: ${nutritionFocus}
- Ziele: ${healthGoals}
- Equipment: ${equipment}

## SAISONALES GEMÜSE (Dezember, Schweiz)
Verfügbar: Lauch, Wirz, Rosenkohl, Schwarzwurzel, Randen, Karotten, Knollensellerie, Kürbis, Chinakohl, Chicorée
Bevorzugt (User mag): ${topIngredients}

## ANFRAGE
- Tage: ${selectedDaysStr}
- Mahlzeiten: ${request.selected_slots?.join(', ') || 'lunch, dinner'}
- Woche startet: ${weekStart.toISOString().split('T')[0]}
- Spezielle Wünsche: ${request.special_request || 'keine'}

## WICHTIGE RICHTLINIEN
1. Jede Mahlzeit verwendet mindestens 1 saisonales Gemüse
2. Abwechslung über die Woche (nicht 3x Pasta)
3. Kinderfreundliche Optionen wenn Kinder dabei
4. Meal-Prep berücksichtigen: Zutaten wiederverwenden wo sinnvoll
5. Gesamte Kochzeit pro Mahlzeit MUSS unter ${maxTime} Min sein

## OUTPUT FORMAT (JSON)
{
  "weekplan": [
    {
      "date": "2025-12-09",
      "dayName": "Montag",
      "meals": {
        "lunch": {
          "title": "Lauch-Risotto",
          "description": "Cremiges Risotto mit saisonalem Lauch",
          "mainVegetable": "Lauch",
          "prepTimeMin": 10,
          "cookTimeMin": 25,
          "servings": ${householdSize},
          "difficulty": "easy",
          "isVegetarian": true,
          "isVegan": false,
          "category": "main",
          "ingredients": [
            {"item": "Risotto-Reis", "amount": "300", "unit": "g"},
            {"item": "Lauch", "amount": "2", "unit": "Stangen"}
          ],
          "steps": ["Schritt 1...", "Schritt 2..."]
        },
        "dinner": {
          "title": "...",
          "description": "...",
          "mainVegetable": "...",
          "prepTimeMin": 0,
          "cookTimeMin": 0,
          "servings": ${householdSize},
          "difficulty": "easy",
          "isVegetarian": false,
          "isVegan": false,
          "category": "main",
          "ingredients": [],
          "steps": []
        }
      }
    }
  ],
  "mealPrepTips": [
    "Lauch am Sonntag vorbereiten für Mo & Mi",
    "Reis für Mo & Di kochen"
  ],
  "shoppingListSummary": {
    "vegetables": ["Lauch: 4 Stangen", "Wirz: 1 Kopf"],
    "staples": ["Risotto-Reis: 600g", "Gemüsebrühe: 1.5L"],
    "dairy": ["Parmesan: 100g", "Butter: 50g"],
    "other": []
  }
}

Antworte NUR mit dem JSON, ohne Markdown.
`;
}

// === API ENDPOINTS ===

// Health check
app.get('/health', (req, res) => {
  res.json({ status: 'ok' });
});

// Generate recipe
app.post('/api/ai/generate-recipe', authMiddleware, premiumMiddleware, async (req, res) => {
  console.log('=== RECIPE GENERATION START ===');
  console.log('Request body:', JSON.stringify(req.body));
  try {
    // Get user profile
    console.log('Getting user profile...');
    const userProfile = await getUserProfile(req.userId);
    console.log('User profile:', userProfile ? 'found' : 'not found');

    // Get seasonal vegetables from database
    console.log('Getting seasonal vegetables...');
    const seasonalVegetables = await getSeasonalVegetables();
    console.log('Seasonal vegetables:', seasonalVegetables.length, 'found');

    // Build prompt with all context
    console.log('Building prompt...');
    const prompt = buildRecipePrompt(req.body, userProfile, req.aiProfile, seasonalVegetables);
    console.log('Prompt length:', prompt.length);

    // Call Gemini
    console.log('Calling Gemini API...');
    const response = await callGemini(prompt);
    console.log('Gemini response received!');
    console.log('Response result:', JSON.stringify(response.result, null, 2));

    // Log request
    await logAIRequest(req.userId, 'recipe_gen', response.usage?.totalTokens, true);

    console.log('=== RECIPE GENERATION SUCCESS ===');
    res.json({ recipe: response.result });
  } catch (e) {
    console.error('Recipe generation error:', e);
    await logAIRequest(req.userId, 'recipe_gen', 0, false, e.message);
    res.status(500).json({ error: 'Recipe generation failed', message: e.message });
  }
});

// Generate weekplan
app.post('/api/ai/generate-weekplan', authMiddleware, premiumMiddleware, async (req, res) => {
  try {
    const userProfile = await getUserProfile(req.userId);
    const prompt = buildWeekplanPrompt(req.body, userProfile, req.aiProfile);

    const response = await callGemini(prompt, {
      temperature: 0.8,
      maxOutputTokens: 4096
    });

    await logAIRequest(req.userId, 'weekplan_gen', response.usage?.totalTokens, true);

    res.json(response.result);
  } catch (e) {
    console.error('Weekplan generation error:', e);
    await logAIRequest(req.userId, 'weekplan_gen', 0, false, e.message);
    res.status(500).json({ error: 'Weekplan generation failed', message: e.message });
  }
});

// Get quota status
app.get('/api/ai/quota', authMiddleware, premiumMiddleware, async (req, res) => {
  try {
    const startOfMonth = new Date();
    startOfMonth.setDate(1);
    startOfMonth.setHours(0, 0, 0, 0);

    const requests = await pb.collection('ai_requests').getList(1, 100, {
      filter: `user_id = "${req.userId}" && request_type = "image_gen" && created >= "${startOfMonth.toISOString()}"`,
    });

    const limit = 10; // Premium limit
    const used = requests.items.length;

    res.json({
      allowed: used < limit,
      remaining: limit - used,
      used: used,
      limit: limit,
    });
  } catch (e) {
    res.status(500).json({ error: 'Failed to get quota' });
  }
});

app.listen(PORT, () => {
  console.log(`Saisonier AI Service running on port ${PORT}`);
  console.log(`PocketBase URL: ${POCKETBASE_URL}`);
  console.log(`Gemini Model: ${GEMINI_MODEL}`);
});
