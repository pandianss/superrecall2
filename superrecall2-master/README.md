# SuperRecall

SuperRecall is a Flutter-based mobile learning app for busy professionals preparing for competitive and professional exams. This repository now starts from the research report in [deep-research-report.md](deep-research-report.md) and translates it into a working product foundation instead of a blank starter app.

## What is in place

- Flutter project scaffold with Firebase (Auth, Firestore, Analytics) integration.
- Feature-first architecture: `lib/features/{study, ai, engagement}`.
- Spaced Repetition (SRS) engine using Isar local storage and Cloud Sync.
- Professional exam catalogs in `assets/catalogs/` (CAIIB, UPSC, SSC CGL).
- Advanced Analytics Dashboard with mastery and retention visualizations.
- AI-Powered Tutoring (Gemini) for lesson explanations and quiz generation.
- Identity Management: Anonymous start with optional account linking.

## Product direction

The initial product should emphasize:

- Micro-lessons built for 5 to 15 minute study sessions.
- Retrieval practice after each concept.
- Spaced repetition for revision.
- Adaptive practice around weak areas.
- Offline-friendly study flows for commuters and working learners.
- A reusable hierarchy of `exam -> subject -> module -> topic` so new exams can be added without redesigning the app.
- Topic-level variation in exam format, including patterns like `MCQ`, `numerical`, `essay`, `short answer`, and `case study`.
- Equation-capable lesson content for math-heavy subjects.

## Suggested next build steps

1. Finish full GoRouter setup across all screens.
2. Build interactive quiz flows inside QuizDetailScreen.
3. Enhance spaced repetition algorithm with machine learning heuristics.
4. Implement offline storage and background sync.

## Run locally

```bash
flutter pub get
flutter run
```
