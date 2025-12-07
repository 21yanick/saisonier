# Phase 16: AI Bildgenerierung (Premium)

**Status:** Geplant
**Ziel:** Wunderschöne, realistische Food-Fotos für Rezepte.

## 1. Scope & Features

### 1.1 Image Generation
- Nutzung von Imagen 3 (via Vertex AI) oder Gemini Pro Vision.
- Generierung von hochwertigen Food-Fotos.

### 1.2 Storage & Caching
- Generierte Bilder sind teuer (Rechenzeit & Geld).
- **Strategie:** Bild generieren -> In PocketBase hochladen -> URL im Rezept speichern.
- Niemals bei jedem View neu generieren!

### 1.3 Quotas
- Premium: Begrenzte Anzahl (z.B. 10/Monat).
- Pro: Höheres Limit oder Unlimitiert (Kalkulation beachten!).

## 2. Technical Details

### 2.1 Architecture
- **App:** `pb.collection('ai_images').create({ recipe_id: '...' })`.
- **PocketBase Hook:**
  1. Validiert Quota (Premium Limit).
  2. Ruft Imagen 3 / Gemini Pro Vision API auf.
  3. Lädt das Resultat-Bild direkt in PocketBase Storage.
  4. Gibt URL zurück.

### 2.2 Prompting
- Stil-Vorgaben hardcoden ("Professional food photography, appetizing...").
- Zutaten dynamisch einfügen.

## 3. UI/UX
- **Gallery Select:** AI liefert oft 4 Variationen. User wählt eine aus, diese wird gespeichert.
- **Loading:** Dauert oft 5-10s. Netter Loading-Screen / Animation nötig.

## 4. Acceptance Criteria
- [ ] User kann Bild generieren und auswählen.
- [ ] Gewähltes Bild wird permanent gespeichert.
- [ ] Quota-Verbrauch wird korrekt gezählt.
