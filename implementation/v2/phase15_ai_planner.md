# Phase 15: AI Wochenplaner (Premium)

**Status:** Geplant
**Ziel:** Vollautomatische Erstellung eines Wochenplans basierend auf Saison, Profil & Vorlieben.

## 1. Scope & Features

### 1.1 Smart Planning Algorithm
- Chain-of-Thought Prompting via Gemini Pro (oder Flash 2.0).
- Berücksichtigung von:
  - User Profil (Allergien, Kinder, Dislikes).
  - Saison (Aktueller Monat).
  - "Meal Prep" Logik (gleiche Zutaten mehrfach nutzen).

### 1.2 Constraints
- Strikte Validierung der Allergien (Safety First).
- Visuelle Feedback-Loop: User kann Plan prüfen vor Übernahme.

## 2. Technical Details

### 2.1 Dependencies
- `GEMINI_API_KEY` (Server Environment).
- `pb_hooks` (Server Side Logic).

### 2.2 Logic Flow
1. **Gather Context:** Profil laden, aktuelle Saison-Gemüse laden.
2. **Build Prompt:** Kontext + Constraints + Output Format (JSON).
3. **Generate:** API Call.
4. **Validate/Parse:** JSON prüfen, ggf. Retry bei Format-Fehlern.
5. **Present:** Vorschau für User.

### 2.3 Fallback Strategy
- Wenn AI Service down: Hinweis zeigen oder lokalen Zufalls-Generator nutzen (aus Favoriten).

## 3. UI/UX
- **Planner Wizard:** "Plan für nächste Woche erstellen" -> "Für wen?" -> "Go".
- **Interactive Review:** User kann einzelne Tage neu "würfeln" lassen.

## 4. Acceptance Criteria
- [ ] Plan respektiert Allergien strikt.
- [ ] Plan enthält nur saisonale Zutaten.
- [ ] Generierte Rezepte existieren (oder sind als generiert markiert).
- [ ] Übernahme in den `WeekPlan` funktioniert fehlerfrei.
