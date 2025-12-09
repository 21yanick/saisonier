# Phase 16: AI Bildgenerierung (Premium)

**Status:** Geplant
**Prerequisite:** Phase 14 (AI Infrastructure)

---

## 1. Übersicht

AI-generierte Food-Fotos für Rezepte. Ermöglicht hochwertige Bilder für User-erstellte und AI-generierte Rezepte ohne dass User selbst fotografieren müssen.

### 1.1 Kernkonzept

```
┌──────────────────────────────────────────────────────────────────┐
│                    AI BILDGENERIERUNG                             │
├──────────────────────────────────────────────────────────────────┤
│                                                                   │
│  Rezept ohne Bild                   Rezept mit AI-Bild           │
│  ┌─────────────────────┐           ┌─────────────────────┐       │
│  │  ┌───────────────┐  │           │  ┌───────────────┐  │       │
│  │  │   🍽️          │  │    AI     │  │  [Appetizing  │  │       │
│  │  │   Kein Bild   │  │  ────▶   │  │   Food Photo] │  │       │
│  │  │               │  │           │  │               │  │       │
│  │  └───────────────┘  │           │  └───────────────┘  │       │
│  │                     │           │                     │       │
│  │  Lauch-Risotto      │           │  Lauch-Risotto      │       │
│  │  [📷 Bild generieren]│           │  ✓ AI-generiert     │       │
│  └─────────────────────┘           └─────────────────────┘       │
│                                                                   │
└──────────────────────────────────────────────────────────────────┘
```

### 1.2 Scope

| Component | Beschreibung |
|-----------|--------------|
| Image Generation Trigger | Button in Recipe Editor/Detail |
| PocketBase Hook | Server-side Imagen/Gemini Call |
| Quota Tracking | 10/Monat Premium, Unlimited Pro |
| Selection UI | 4 Varianten zur Auswahl |
| PocketBase Storage | Permanente Speicherung |

---

## 2. Quota System

### 2.1 Limits

| Tier | Bilder/Monat | Auflösung |
|------|--------------|-----------|
| Free | 0 | - |
| Premium | 10 | 2K (1024x1024) |
| Pro | Unlimited | 4K (2048x2048) |

### 2.2 Tracking

```javascript
// backend/pb_hooks/ai_handler.js

async function checkImageQuota(userId) {
  const startOfMonth = new Date();
  startOfMonth.setDate(1);
  startOfMonth.setHours(0, 0, 0, 0);

  const requests = await $app.dao().findRecordsByFilter(
    "ai_requests",
    `user_id = '${userId}' && request_type = 'image_gen' && created >= '${startOfMonth.toISOString()}'`
  );

  const aiProfile = await $app.dao().findFirstRecordByData("ai_profiles", "user_id", userId);
  const isPro = await checkProSubscription(userId);

  if (isPro) return { allowed: true, remaining: -1 };

  const limit = 10; // Premium limit
  const used = requests.length;

  return {
    allowed: used < limit,
    remaining: limit - used,
    used: used,
    limit: limit,
  };
}
```

---

## 3. Image Generation

### 3.1 PocketBase Endpoint

```javascript
// backend/pb_hooks/ai_handler.js

routerAdd("POST", "/api/ai/generate-image", async (c) => {
  const user = c.get("authRecord");
  if (!user) {
    return c.json(401, { error: "Unauthorized" });
  }

  // Premium check
  const aiProfile = await $app.dao().findFirstRecordByData("ai_profiles", "user_id", user.id);
  if (!aiProfile) {
    return c.json(403, { error: "Premium required" });
  }

  // Quota check
  const quota = await checkImageQuota(user.id);
  if (!quota.allowed) {
    return c.json(429, {
      error: "Quota exceeded",
      used: quota.used,
      limit: quota.limit,
    });
  }

  const body = $apis.requestInfo(c).data;
  const { recipeTitle, recipeDescription, mainIngredients } = body;

  // Build image prompt
  const prompt = buildImagePrompt(recipeTitle, recipeDescription, mainIngredients);

  // Call Imagen API
  const images = await generateImages(prompt, 4); // 4 variations

  // Store images temporarily (URLs expire)
  const storedUrls = [];
  for (const imageData of images) {
    const url = await storeTemporaryImage(imageData);
    storedUrls.push(url);
  }

  // Log request
  await logAIRequest(user.id, "image_gen", { count: 1 });

  return c.json(200, {
    images: storedUrls,
    remaining: quota.remaining - 1,
  });
});
```

### 3.2 Prompt Template

```javascript
function buildImagePrompt(title, description, ingredients) {
  return `
Professional food photography of: ${title}

${description ? `Description: ${description}` : ''}

Style:
- Appetizing, mouthwatering presentation
- Natural daylight, soft shadows
- Shallow depth of field (f/2.8)
- Hero shot, 45-degree angle
- Rustic Swiss kitchen setting
- Wooden table or slate board
- Fresh herb garnish

Main ingredients visible: ${ingredients.slice(0, 3).join(', ')}

Mood: Warm, inviting, homemade, authentic
Quality: Professional food magazine cover
DO NOT include: text, watermarks, logos, hands, people
`;
}
```

### 3.3 Imagen API Call

```javascript
async function generateImages(prompt, count = 4) {
  const apiKey = process.env.GEMINI_API_KEY;

  // Using Gemini's image generation (Imagen 3)
  const response = await fetch(
    `https://generativelanguage.googleapis.com/v1beta/models/imagen-3.0-generate-001:predict?key=${apiKey}`,
    {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        instances: [{ prompt: prompt }],
        parameters: {
          sampleCount: count,
          aspectRatio: "1:1",
          safetyFilterLevel: "block_some",
        },
      }),
    }
  );

  const data = await response.json();
  return data.predictions.map(p => p.bytesBase64Encoded);
}
```

---

## 4. Selection UI

### 4.1 Image Selection Modal

```
┌─────────────────────────────────┐
│  📷 Bild auswählen         [X]  │
├─────────────────────────────────┤
│                                 │
│  Wähle das beste Bild:          │
│                                 │
│  ┌───────────┐ ┌───────────┐   │
│  │           │ │           │   │
│  │  [Var 1]  │ │  [Var 2]  │   │
│  │           │ │           │   │
│  └───────────┘ └───────────┘   │
│                                 │
│  ┌───────────┐ ┌───────────┐   │
│  │           │ │           │   │
│  │  [Var 3]  │ │  [Var 4]  │   │
│  │           │ │           │   │
│  └───────────┘ └───────────┘   │
│                                 │
│  ─────────────────────────────  │
│                                 │
│  Noch 7 Bilder übrig diesen     │
│  Monat.                         │
│                                 │
│  [Abbrechen]    [✓ Auswählen]   │
│                                 │
└─────────────────────────────────┘
```

### 4.2 Implementation

```dart
// lib/features/ai/presentation/widgets/image_selection_modal.dart

class ImageSelectionModal extends ConsumerStatefulWidget {
  final String recipeId;
  final String recipeTitle;
  final List<String> mainIngredients;
}

class _ImageSelectionModalState extends ConsumerState<ImageSelectionModal> {
  List<String> generatedImages = [];
  int? selectedIndex;
  bool isGenerating = true;

  @override
  void initState() {
    super.initState();
    _generateImages();
  }

  Future<void> _generateImages() async {
    try {
      final result = await ref.read(aiServiceProvider).generateRecipeImage(
        recipeTitle: widget.recipeTitle,
        mainIngredients: widget.mainIngredients,
      );

      setState(() {
        generatedImages = result.images;
        isGenerating = false;
      });
    } catch (e) {
      _showError(e);
      Navigator.pop(context);
    }
  }

  Future<void> _selectImage() async {
    if (selectedIndex == null) return;

    final selectedUrl = generatedImages[selectedIndex!];

    // Upload to PocketBase as permanent file
    final permanentUrl = await ref.read(aiServiceProvider).saveRecipeImage(
      recipeId: widget.recipeId,
      imageUrl: selectedUrl,
    );

    // Update recipe with new image
    await ref.read(recipeRepositoryProvider).updateImage(
      widget.recipeId,
      permanentUrl,
    );

    Navigator.pop(context, permanentUrl);
  }
}
```

---

## 5. Permanent Storage

### 5.1 Save Selected Image

```javascript
// backend/pb_hooks/ai_handler.js

routerAdd("POST", "/api/ai/save-image", async (c) => {
  const user = c.get("authRecord");
  const { recipeId, imageData } = $apis.requestInfo(c).data;

  // Verify recipe ownership
  const recipe = await $app.dao().findRecordById("recipes", recipeId);
  if (recipe.get("user_id") !== user.id) {
    return c.json(403, { error: "Not your recipe" });
  }

  // Decode base64 and save as file
  const buffer = Buffer.from(imageData, 'base64');
  const filename = `ai_${recipeId}_${Date.now()}.webp`;

  // Update recipe record with file
  recipe.set("image", new $apis.filesystem.File(filename, buffer));
  await $app.dao().saveRecord(recipe);

  // Return permanent URL
  const url = `${$app.settings().meta.appUrl}/api/files/recipes/${recipeId}/${filename}`;

  return c.json(200, { url: url });
});
```

---

## 6. Trigger Points

### 6.1 Recipe Editor

```dart
// In RecipeEditorScreen

Widget _buildImageSection() {
  return Column(
    children: [
      if (recipe.image != null)
        CachedNetworkImage(imageUrl: recipe.image!)
      else
        _buildPlaceholder(),

      const SizedBox(height: 12),

      Row(
        children: [
          // Standard upload
          OutlinedButton.icon(
            onPressed: _pickImage,
            icon: Icon(Icons.photo_library),
            label: Text('Hochladen'),
          ),

          const SizedBox(width: 12),

          // AI generation (Premium only)
          _buildAIImageButton(),
        ],
      ),
    ],
  );
}

Widget _buildAIImageButton() {
  final isPremium = ref.watch(subscriptionProvider).isPremium;

  return ElevatedButton.icon(
    onPressed: isPremium
        ? () => _showImageGenerationModal()
        : () => _showPaywall(),
    icon: Icon(Icons.auto_awesome),
    label: Text('AI Bild'),
    style: ElevatedButton.styleFrom(
      backgroundColor: isPremium ? AppColors.primaryGreen : Colors.grey,
    ),
  );
}
```

### 6.2 Recipe Detail (for AI-generated recipes)

```dart
// In RecipeDetailScreen - for recipes without images

if (recipe.image == null && recipe.source == RecipeSource.ai) {
  // Show prominent "Generate Image" CTA
  Widget(
    child: Column(
      children: [
        Icon(Icons.image_not_supported, size: 64),
        Text('Kein Bild vorhanden'),
        SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: _generateImage,
          icon: Icon(Icons.auto_awesome),
          label: Text('AI Bild generieren'),
        ),
      ],
    ),
  );
}
```

---

## 7. Loading States

### 7.1 Generation Animation

```dart
// Show while generating (5-15 seconds)

class ImageGenerationLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Animated chef/camera icon
        Lottie.asset('assets/animations/cooking.json'),

        SizedBox(height: 24),

        Text(
          'Kreiere dein Bild...',
          style: Theme.of(context).textTheme.titleMedium,
        ),

        SizedBox(height: 8),

        Text(
          'Das kann 10-15 Sekunden dauern',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
```

---

## 8. File Structure

```
lib/features/ai/
├── presentation/
│   └── widgets/
│       ├── image_selection_modal.dart
│       └── image_generation_loader.dart
│
└── domain/
    └── models/
        └── image_generation_result.dart
```

---

## 9. Acceptance Criteria

### Must Have
- [ ] "AI Bild generieren" Button nur für Premium sichtbar
- [ ] Quota-Check vor Generation
- [ ] 4 Varianten werden generiert und angezeigt
- [ ] User kann eine Variante auswählen
- [ ] Ausgewähltes Bild wird permanent in PocketBase gespeichert
- [ ] Recipe wird mit neuem Bild aktualisiert
- [ ] Verbleibende Quota wird angezeigt

### Should Have
- [ ] Schöne Loading-Animation während Generation
- [ ] Error Handling bei API-Fehlern
- [ ] "Neu generieren" Option wenn keine Variante gefällt
- [ ] Quota-Warning bei < 3 verbleibenden Bildern

### Nice to Have
- [ ] Zoom-Ansicht für Varianten
- [ ] "Stil wählen" Option (rustikal, modern, minimal)
- [ ] Batch-Generation für Wochenplan-Rezepte

---

## 10. Cost Considerations

### 10.1 Imagen 3 Pricing (Dec 2025)

| Resolution | Cost per Image |
|------------|----------------|
| 1024x1024 | ~$0.04 |
| 2048x2048 | ~$0.08 |

### 10.2 Monthly Cost per User

| Tier | Images | Cost |
|------|--------|------|
| Premium | 10 x 2K | ~$0.40 |
| Pro (avg 25) | 25 x 4K | ~$2.00 |

### 10.3 Optimization Strategies

- Cache prompts für identische Rezepte
- Batch-Generation (4 auf einmal statt 4x1)
- Downsample für Thumbnail-Vorschau

---

*Phase 16 - AI Bildgenerierung*
*Prerequisite: Phase 14 (AI Infrastructure)*
*Estimated Effort: 1-2 Wochen*
