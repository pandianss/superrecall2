# Product Foundation

This document converts the research report into the first implementation baseline for SuperRecall.

## Core promise

Help working learners prepare for multiple exams through short, structured, high-retention study loops that fit real schedules.

## MVP principles

- Keep sessions short and specific.
- Make every lesson end with active recall.
- Re-surface important material through spaced review.
- Show progress clearly so learners feel momentum.
- Design for unreliable connectivity and interrupted sessions.
- Keep the content model exam-agnostic so new catalogs can be added cleanly.

## Primary user flow

1. User chooses an exam catalog and sets a target date.
2. App creates a study plan and recommends a daily lesson.
3. User completes one micro-lesson.
4. User answers a short recall quiz.
5. App schedules review items based on performance.
6. User tracks streaks, weak areas, and mock test readiness.

## First feature slices

### Slice 1

- App shell
- Home dashboard
- Exam catalog selection
- Subject, module, and topic explorer
- MVP feature framing

### Slice 2

- Onboarding
- Exam selection
- Target date capture
- Placeholder generated plan

### Slice 3

- Lesson detail screen
- Quiz flow
- Feedback states
- Progress tracking

### Slice 4

- Spaced review queue
- Offline caching
- Notification hooks

## Technical direction

- Flutter front end for a single mobile codebase.
- Modular feature structure as the codebase grows.
- Backend-ready domain models for exams, subjects, modules, topics, lessons, quizzes, and plans.
- Local-first persistence for progress and downloaded content.

## Immediate engineering priorities

1. Move the single-file UI into reusable widgets and folders.
2. Add navigation and screen structure.
3. Define core data models.
4. Add tests for visible product behavior.
