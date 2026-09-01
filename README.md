# Socibot — Omnichannel Customer Messaging Platform

Unifies Instagram Direct, Facebook Messenger, and WhatsApp Business
conversations into a single inbox. Built with Flutter + Riverpod + GoRouter
on top of Supabase (Postgres, Auth, Realtime, Edge Functions).

Status: **AŞAMA 0 — Architecture setup** (project structure, theming,
routing, and Supabase client wiring). No auth or inbox screens yet.

## Project structure

```
lib/
  app/          # App-level wiring: MaterialApp.router, theme, GoRouter
  core/         # Cross-feature building blocks: constants, errors,
                # extensions, Supabase service, shared widgets
  features/     # Feature-first modules (auth, dashboard, inbox,
                # conversations, contacts, channels, settings), each
                # split into data/domain/presentation
```

Flutter never talks to Instagram/Facebook/WhatsApp or Supabase's service
role directly — all of that lives behind Supabase Edge Functions
(`supabase/functions`, added starting AŞAMA 10).

## Environment configuration

The app takes its Supabase project URL and publishable (anon) key via
`--dart-define-from-file`, so no secret ever lives in source control or in
the compiled client beyond the publishable key.

```bash
cp config/dev.example.json config/dev.json
# fill in your Supabase project URL + publishable key
flutter run --dart-define-from-file=config/dev.json
```

`config/*.json` (besides the `.example.json` templates) is gitignored.
Missing/empty values fail fast at startup with a clear error instead of a
confusing Supabase client error later.

## Running

```bash
flutter pub get
flutter run --dart-define-from-file=config/dev.json -d chrome   # or linux, etc.
flutter analyze
flutter test
```
