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

// === SMART WEEKPLAN HELPER FUNCTIONS ===

// Get IDs of vegetables that are in season for a given month
async function getSeasonalVegetableIds(month) {
  try {
    const vegetables = await pb.collection('vegetables').getFullList({
      filter: `months ~ "${month}"`,
    });
    return vegetables.map(v => v.id);
  } catch (e) {
    console.error('Failed to get seasonal vegetable IDs:', e);
    return [];
  }
}

// Get IDs of recipes the user has favorited
// TODO: Expand when favorites system is fully implemented
async function getUserFavoriteRecipeIds(userId) {
  try {
    const recipes = await pb.collection('recipes').getFullList({
      filter: `is_favorite = true`,
    });
    return recipes.map(r => r.id);
  } catch (e) {
    return [];
  }
}

// Filter and score recipes based on user profile and request filters
async function getEligibleRecipes(userId, userProfile, filters = {}) {
  // 1. Load all recipes (curated + user's own)
  let recipes = await pb.collection('recipes').getFullList({
    filter: `source = "curated" || user_id = "${userId}"`,
  });

  console.log(`Loaded ${recipes.length} total recipes`);

  // 2. Hard-Filter: Allergens (NEVER include recipes with user's allergens)
  const allergens = userProfile?.allergens || [];
  if (allergens.length > 0) {
    recipes = recipes.filter(r => {
      for (const allergen of allergens) {
        const fieldName = `contains_${allergen}`;
        if (r[fieldName] === true) return false;
      }
      return true;
    });
    console.log(`After allergen filter: ${recipes.length} recipes`);
  }

  // 3. Hard-Filter: Diet (vegetarian/vegan)
  if (filters.forceVegan || userProfile?.diet === 'vegan') {
    recipes = recipes.filter(r => r.is_vegan === true);
    console.log(`After vegan filter: ${recipes.length} recipes`);
  } else if (filters.forceVegetarian || userProfile?.diet === 'vegetarian') {
    recipes = recipes.filter(r => r.is_vegetarian === true);
    console.log(`After vegetarian filter: ${recipes.length} recipes`);
  }

  // 4. Hard-Filter: Max cooking time
  const maxTime = filters.forceQuick ? 30 : (userProfile?.max_cooking_time_min || 90);
  recipes = recipes.filter(r => {
    const totalTime = (r.prep_time_min || 0) + (r.cook_time_min || 0);
    return totalTime <= maxTime;
  });
  console.log(`After time filter (max ${maxTime}min): ${recipes.length} recipes`);

  // 5. Hard-Filter: Skill level
  const skillOrder = { 'easy': 1, 'medium': 2, 'hard': 3 };
  const userSkillLevel = skillOrder[userProfile?.skill] || 3; // Default to hard (no restriction)
  recipes = recipes.filter(r => {
    const recipeSkill = skillOrder[r.difficulty] || 1;
    return recipeSkill <= userSkillLevel;
  });
  console.log(`After skill filter: ${recipes.length} recipes`);

  // 6. Soft-Scoring: Add metadata for prompt
  const currentMonth = new Date().getMonth() + 1;
  const seasonalVegetableIds = await getSeasonalVegetableIds(currentMonth);
  const userFavoriteIds = await getUserFavoriteRecipeIds(userId);

  recipes = recipes.map(r => {
    let score = 1.0;
    const flags = [];

    // Seasonal boost (1.5x)
    if (seasonalVegetableIds.includes(r.vegetable_id)) {
      score *= 1.5;
      flags.push('seasonal');
    }

    // Favorites boost (2x if enabled)
    if (filters.boostFavorites && userFavoriteIds.includes(r.id)) {
      score *= 2.0;
      flags.push('favorite');
    }

    // Own recipes boost (1.8x if enabled)
    if (filters.boostOwnRecipes && r.user_id === userId) {
      score *= 1.8;
      flags.push('own');
    }

    // Inspiration-based boosts
    if (filters.inspiration === 'budgetWeek') {
      const tags = r.tags || [];
      if (tags.includes('budget') || tags.includes('günstig')) score *= 1.5;
    }
    if (filters.inspiration === 'comfortWeek') {
      const tags = r.tags || [];
      if (tags.includes('comfort') || tags.includes('herzhaft')) score *= 1.5;
    }
    if (filters.inspiration === 'lightWeek') {
      const tags = r.tags || [];
      if (tags.includes('leicht') || tags.includes('gesund')) score *= 1.5;
    }

    return { ...r, _score: score, _flags: flags };
  });

  // 7. Sort by score and limit
  recipes.sort((a, b) => b._score - a._score);
  const limited = recipes.slice(0, 60);
  console.log(`Returning top ${limited.length} recipes by score`);

  return limited;
}

// Build compact recipe summaries for the prompt
function buildRecipeSummaries(recipes) {
  // Group by category
  const byCategory = {};
  const catNames = {
    main: 'Hauptgerichte',
    side: 'Beilagen',
    soup: 'Suppen',
    salad: 'Salate',
    breakfast: 'Frühstück',
    dessert: 'Desserts',
    snack: 'Snacks',
  };

  for (const r of recipes) {
    const cat = r.category || 'main';
    if (!byCategory[cat]) byCategory[cat] = [];

    const totalTime = (r.prep_time_min || 0) + (r.cook_time_min || 0);
    const flags = [];

    if (r.is_vegetarian) flags.push('veg');
    if (r.is_vegan) flags.push('vegan');
    if (r._flags?.includes('favorite')) flags.push('⭐');
    if (r._flags?.includes('own')) flags.push('👤');
    if (r._flags?.includes('seasonal')) flags.push('🌿');

    const flagStr = flags.length > 0 ? `, ${flags.join(' ')}` : '';
    byCategory[cat].push(`[${r.id}] ${r.title} (${totalTime}min${flagStr})`);
  }

  // Build output string
  let output = '';
  for (const [cat, items] of Object.entries(byCategory)) {
    if (items.length > 0) {
      output += `\n### ${catNames[cat] || cat}\n`;
      output += items.map(i => `• ${i}`).join('\n');
      output += '\n';
    }
  }

  return output;
}

// Build the smart weekplan prompt with context analysis
function buildSmartWeekplanPrompt(context, recipeSummaries) {
  const dayNamesDE = ['Sonntag', 'Montag', 'Dienstag', 'Mittwoch', 'Donnerstag', 'Freitag', 'Samstag'];

  // Parse selected dates and build day info
  const selectedDates = context.selectedDates || [];
  console.log('Selected dates received:', selectedDates);

  const dayInfos = selectedDates
    .filter(dateStr => dateStr && typeof dateStr === 'string')
    .map(dateStr => {
      const date = new Date(dateStr + 'T00:00:00');
      if (isNaN(date.getTime())) {
        console.warn('Invalid date string:', dateStr);
        return null;
      }
      return {
        date: dateStr,
        dayName: dayNamesDE[date.getDay()],
      };
    })
    .filter(Boolean);

  const selectedDaysStr = dayInfos.map(d => `${d.dayName} (${d.date})`).join(', ');
  const dayDates = Object.fromEntries(dayInfos.map(d => [d.dayName, d.date]));

  // Format existing meals
  const existingMealsInfo = context.existingMeals?.length > 0
    ? context.existingMeals.map(m => `- ${m.date} ${m.slot}: ${m.title}`).join('\n')
    : 'Keine';

  return `
Du bist ein persönlicher Schweizer Meal-Planner der STRATEGISCH denkt.

## DEINE AUFGABE

Erstelle einen DURCHDACHTEN Wochenplan. Nicht "zufällige Rezepte", sondern
einen Plan der zur WOCHE dieses Users passt.

## USER-KONTEXT DIESE WOCHE

"${context.weekContext || ''}"

${context.weekContext ? `ANALYSIERE diesen Kontext und extrahiere:
- Zeit-Constraints: Welche Tage sind stressig/entspannt?
- Events: Gäste, Geburtstage, besondere Anlässe?
- Vorhandene Zutaten: Was muss verwertet werden?
- Explizite Wünsche: Was will der User diese Woche?` : `WICHTIG: Der User hat KEINEN speziellen Kontext angegeben!
- contextAnalysis.timeConstraints = {} (leer)
- contextAnalysis.events = {} (leer)
- contextAnalysis.ingredientsToUse = [] (leer)
- contextAnalysis.displaySummary = null oder kurzer generischer Text
- Erfinde KEINE Constraints, Events oder Zutaten!
- Plane einfach eine abwechslungsreiche, saisonale Woche.`}

## USER-PROFIL (IMMER EINHALTEN)

- Haushalt: ${context.householdSize} Personen${context.childrenCount > 0 ? ` (davon ${context.childrenCount} Kinder)` : ''}
- Ernährung: ${context.diet || 'omnivor'}
- Allergene: ${context.allergens?.join(', ') || 'keine'} → NIEMALS verwenden!
- Dislikes: ${context.dislikes?.join(', ') || 'keine'} → MÖGLICHST VERMEIDEN!
- Max. Zeit pro Rezept: ${context.maxTime} Minuten
- Kochskill: ${context.skill || 'beginner'}

## PRÄFERENZEN

- Lieblings-Küchen: ${context.cuisinePreferences?.join(', ') || 'alle'}
- Geschmack: ${context.flavorProfile?.join(', ') || 'ausgewogen'}
${context.inspiration ? `- Inspiration: ${context.inspiration}` : ''}
${context.boostFavorites ? '- FAVORITEN bevorzugen (⭐)!' : ''}
${context.boostOwnRecipes ? '- EIGENE REZEPTE bevorzugen (👤)!' : ''}

## STRATEGISCHES DENKEN

Für JEDEN Tag, überlege:

1. ZEIT: Was weisst du über diesen Tag? (aus Kontext)
   - "Stress" / "wenig Zeit" → schnelles Rezept
   - "Homeoffice" / "frei" → mehr Zeit ok

2. EVENT: Passiert was Besonderes?
   - Gäste → festlich, mehr Portionen
   - Geburtstag → besonderes Rezept

3. VORHER: Was wurde gestern gekocht?
   - Reste nutzbar? → Reste-Verwertung!
   - Gleiche Zutat? → Variation statt Wiederholung

4. ZUTATEN: Welche vorhandenen Zutaten einbauen?
   - Food Waste vermeiden!

5. SAISON: Was ist gerade frisch?
   - Saisonale Rezepte (🌿) bevorzugen

## ANFRAGE

- Tage: ${selectedDaysStr}
- Mahlzeiten: ${context.selectedSlots?.join(', ') || 'dinner'}

Verwende diese Datums-Zuordnung:
${Object.entries(dayDates).map(([day, date]) => `- ${day}: ${date}`).join('\n')}

## BEREITS GEPLANT (ÜBERSPRINGEN!)

${existingMealsInfo}
${context.existingMeals?.length > 0 ? `
WICHTIG: Für die oben gelisteten Tag/Slot-Kombinationen existiert BEREITS ein Rezept!
→ Erstelle KEINEN Eintrag im "meals" Objekt für diese Slots!
→ Der User will nur die LEEREN Slots füllen.` : ''}

## VERFÜGBARE REZEPTE

Legende: ⭐=Favorit, 👤=Eigenes Rezept, 🌿=Saisonal
${recipeSummaries}

KRITISCH: Wähle NUR Rezepte aus dieser Liste!
- Verwende EXAKT die IDs in eckigen Klammern [abc123def...]
- ERFINDE NIEMALS IDs! Keine Placeholder wie "abc123" oder "ECHTE_ID"!
- Wenn du eine ID verwendest die nicht in der Liste ist, wird das Rezept nicht gefunden.

## OUTPUT FORMAT (JSON)

WICHTIG: Das folgende ist nur ein FORMAT-Beispiel. Kopiere NICHT die Werte!
Wenn kein Kontext angegeben wurde, müssen timeConstraints, events, ingredientsToUse LEER sein.

{
  "contextAnalysis": {
    "timeConstraints": {},
    "events": {},
    "ingredientsToUse": [],
    "displaySummary": null
  },
  "weekplan": [
    {
      "date": "YYYY-MM-DD",
      "dayName": "Wochentag",
      "dayContext": null,
      "meals": {
        "dinner": {
          "recipeId": "<ID aus Rezeptliste oben>",
          "reasoning": "<Kurze Begründung>"
        }
      }
    }
  ],
  "strategy": {
    "insights": [
      "Abwechslungsreiche Woche geplant",
      "X saisonale Rezepte verwendet"
    ],
    "seasonalCount": 3,
    "favoritesUsed": 0
  }
}

Wenn der User KONTEXT angegeben hat (z.B. "Mo Stress, Do Gäste"), dann:
- timeConstraints: {"monday": "busy"}
- events: {"thursday": {"type": "guests", "guestCount": 4}}
- displaySummary: "Mo wenig Zeit, Do Gäste"
- dayContext bei den jeweiligen Tagen setzen

## WICHTIG ZU DEN REASONINGS

Die "reasoning" zeigt dem User dass du MITDENKST. Sie muss:
- Kurz sein (1 Satz max)
- Praktischen Mehrwert erklären
- Wenn Kontext vorhanden: Bezug zum Kontext zeigen
- Wenn KEIN Kontext: Saison, Abwechslung oder Rezept-Qualität hervorheben

GUTE Reasonings (MIT Kontext):
- "Schnell weil du wenig Zeit hast"
- "Reste von gestern clever genutzt"
- "Für deine Gäste - beeindruckend!"
- "Dein Lauch wird verwendet"

GUTE Reasonings (OHNE Kontext):
- "Kürbis hat jetzt Hochsaison - perfekt!"
- "Abwechslung nach dem Nudelgericht gestern"
- "Klassiker der Schweizer Küche"
- "Leicht und frisch für zwischendurch"
- "Herzhaft und wärmend für den Winter"

SCHLECHTE Reasonings (IMMER vermeiden):
- "Ein leckeres Gericht"
- "Passt gut"
- "Vegetarisches Rezept"
- Erfundene Constraints wie "weil du wenig Zeit hast" OHNE dass der User das erwähnt hat!

Antworte NUR mit dem JSON, ohne Markdown.
`;
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

// Generate weekplan (legacy - generates recipes)
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

// Smart weekplan generation (DB-based with context analysis)
app.post('/api/ai/generate-smart-weekplan', authMiddleware, premiumMiddleware, async (req, res) => {
  console.log('=== SMART WEEKPLAN GENERATION START ===');
  console.log('Request body:', JSON.stringify(req.body, null, 2));

  try {
    const userId = req.userId;
    const request = req.body;

    // Validate required fields
    if (!request.selected_dates || !Array.isArray(request.selected_dates) || request.selected_dates.length === 0) {
      return res.status(400).json({
        error: 'invalid_request',
        message: 'Keine Tage ausgewählt. Bitte wähle mindestens einen Tag.',
      });
    }

    // 1. Get user profile
    const userProfile = await getUserProfile(userId);
    const aiProfile = req.aiProfile;

    // 2. Get eligible recipes with filters
    const filters = {
      forceVegetarian: request.force_vegetarian,
      forceVegan: request.force_vegan,
      forceQuick: request.force_quick,
      boostFavorites: request.boost_favorites,
      boostOwnRecipes: request.boost_own_recipes,
      inspiration: request.inspiration,
    };
    const eligibleRecipes = await getEligibleRecipes(userId, userProfile, filters);

    if (eligibleRecipes.length === 0) {
      return res.status(400).json({
        error: 'no_recipes',
        message: 'Keine passenden Rezepte gefunden. Passe deine Filter an.',
      });
    }

    // 3. Build recipe summaries for prompt
    const recipeSummaries = buildRecipeSummaries(eligibleRecipes);

    // 4. Build context for prompt
    const context = {
      selectedDates: request.selected_dates || [],
      selectedSlots: request.selected_slots || ['dinner'],
      weekContext: request.week_context || '',
      existingMeals: request.existing_meals || [],
      inspiration: request.inspiration,
      boostFavorites: request.boost_favorites,
      boostOwnRecipes: request.boost_own_recipes,
      // User profile data
      householdSize: userProfile?.household_size || 2,
      childrenCount: userProfile?.children_count || 0,
      diet: userProfile?.diet,
      skill: userProfile?.skill,
      maxTime: request.force_quick ? 30 : (userProfile?.max_cooking_time_min || 60),
      allergens: userProfile?.allergens || [],
      dislikes: userProfile?.dislikes || [],
      // AI profile data
      cuisinePreferences: aiProfile?.cuisine_preferences,
      flavorProfile: aiProfile?.flavor_profile,
    };

    // 5. Build prompt and call Gemini
    const prompt = buildSmartWeekplanPrompt(context, recipeSummaries);
    console.log('Prompt length:', prompt.length);

    const geminiResponse = await callGemini(prompt, {
      temperature: 0.7,
      maxOutputTokens: 4096,
    });

    const result = geminiResponse.result;

    // 6. Load full recipe data for selected recipes
    const recipeIds = new Set();
    for (const day of (result.weekplan || [])) {
      for (const meal of Object.values(day.meals || {})) {
        if (meal.recipeId) recipeIds.add(meal.recipeId);
      }
    }

    const fullRecipes = {};
    const missingRecipes = [];
    for (const id of recipeIds) {
      try {
        const recipe = await pb.collection('recipes').getOne(id);
        fullRecipes[id] = recipe;
      } catch (e) {
        console.warn(`Recipe ${id} not found in DB - AI hallucinated this ID!`);
        missingRecipes.push(id);
      }
    }
    if (missingRecipes.length > 0) {
      console.warn(`=== WARNING: ${missingRecipes.length} recipes not found: ${missingRecipes.join(', ')} ===`);
    }

    // 7. Log request
    await logAIRequest(userId, 'smart_weekplan', geminiResponse.usage?.totalTokens, true);

    // 8. Return response
    console.log('=== SMART WEEKPLAN GENERATION SUCCESS ===');
    res.json({
      contextAnalysis: result.contextAnalysis || {},
      weekplan: result.weekplan || [],
      recipes: fullRecipes,
      strategy: result.strategy || {},
      eligibleRecipeCount: eligibleRecipes.length,
    });

  } catch (e) {
    console.error('Smart weekplan generation error:', e);
    await logAIRequest(req.userId, 'smart_weekplan', 0, false, e.message);
    res.status(500).json({
      error: 'generation_failed',
      message: e.message,
    });
  }
});

// Get eligible recipe count (for UI validation)
app.post('/api/ai/eligible-recipe-count', authMiddleware, premiumMiddleware, async (req, res) => {
  try {
    const userProfile = await getUserProfile(req.userId);
    const filters = {
      forceVegetarian: req.body.force_vegetarian,
      forceVegan: req.body.force_vegan,
      forceQuick: req.body.force_quick,
    };
    const recipes = await getEligibleRecipes(req.userId, userProfile, filters);
    res.json({ count: recipes.length });
  } catch (e) {
    res.status(500).json({ error: e.message });
  }
});

// Refine a single meal through conversation
app.post('/api/ai/refine-meal', authMiddleware, premiumMiddleware, async (req, res) => {
  console.log('=== REFINE MEAL START ===');

  try {
    const { current_plan, day, slot, user_message, day_context } = req.body;

    // Get recipes already used in the plan
    const usedRecipeIds = new Set();
    for (const d of (current_plan || [])) {
      for (const meal of Object.values(d.meals || {})) {
        if (meal.recipeId) usedRecipeIds.add(meal.recipeId);
      }
    }

    // Get available recipes (excluding already used ones)
    const userProfile = await getUserProfile(req.userId);
    const allRecipes = await getEligibleRecipes(req.userId, userProfile, {});
    const availableRecipes = allRecipes.filter(r => !usedRecipeIds.has(r.id));

    // Find current meal info
    const currentDay = current_plan?.find(d => d.date === day);
    const currentMeal = currentDay?.meals?.[slot];

    // Build compact recipe list for prompt
    const recipeList = availableRecipes.slice(0, 30).map(r => {
      const time = (r.prep_time_min || 0) + (r.cook_time_min || 0);
      return `[${r.id}] ${r.title} (${time}min)`;
    }).join('\n');

    // Build refinement prompt
    const dislikes = userProfile?.dislikes || [];
    const prompt = `
Du bist ein hilfsbereiter Meal-Planner im Gespräch mit dem User.
${dislikes.length > 0 ? `\n## USER-DISLIKES (VERMEIDEN!)\n${dislikes.join(', ')}\n` : ''}
## AKTUELLES REZEPT
${currentMeal?.title || currentMeal?.recipeId || 'Nicht bekannt'}
Begründung war: "${currentMeal?.reasoning || ''}"
Tages-Kontext: ${day_context || 'normal'}

## USER-NACHRICHT
"${user_message}"

## DEINE AUFGABE
1. Verstehe was der User will/nicht will
2. Schlage 2-3 passende Alternativen vor
3. Erkläre kurz warum jede Alternative passt

## VERFÜGBARE REZEPTE
${recipeList}

## OUTPUT FORMAT (JSON)

{
  "response": "Verstehe! [Kurze empathische Antwort]. Hier sind Alternativen:",
  "suggestions": [
    {
      "recipeId": "abc123",
      "title": "Rezeptname",
      "reasoning": "Warum das passt (1 Satz)",
      "cookTimeMin": 35
    }
  ]
}

Sei freundlich und hilfreich. Maximal 3 Suggestions.
Antworte NUR mit dem JSON.
`;

    const response = await callGemini(prompt, {
      temperature: 0.8,
      maxOutputTokens: 1024,
    });

    const result = response.result;

    // Load full recipe data for suggestions
    const suggestions = result.suggestions || [];
    for (const suggestion of suggestions) {
      if (suggestion.recipeId) {
        try {
          const recipe = await pb.collection('recipes').getOne(suggestion.recipeId);
          suggestion.recipe = recipe;
        } catch (e) {
          console.warn(`Suggestion recipe ${suggestion.recipeId} not found`);
        }
      }
    }

    await logAIRequest(req.userId, 'refine_meal', response.usage?.totalTokens, true);

    console.log('=== REFINE MEAL SUCCESS ===');
    res.json({
      response: result.response || '',
      suggestions: suggestions,
    });

  } catch (e) {
    console.error('Refine meal error:', e);
    await logAIRequest(req.userId, 'refine_meal', 0, false, e.message);
    res.status(500).json({ error: e.message });
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
