import 'package:flutter/foundation.dart';

/// A temporary, debug-only "signed in" flag for [mockDemoEmail]/
/// [mockDemoPassword] — lets the login screen be exercised for real (type
/// credentials, hit Sign in) without a working Supabase project. No real
/// Supabase session is created; [LoginController.submit] only flips this
/// notifier, and the app router's redirect guard treats it exactly like a
/// real session while [kDebugMode] holds.
///
/// Remove this once real Supabase auth is set up for local development —
/// it exists purely so the UI can be reviewed end to end in the meantime.
final ValueNotifier<bool> mockAuthActive = ValueNotifier<bool>(false);

const String mockDemoEmail = 'demo@socibot.dev';
const String mockDemoPassword = 'demo1234';
