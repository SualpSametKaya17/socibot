/// Compile-time environment configuration.
///
/// Values are injected via `--dart-define-from-file=config/<env>.json`
/// (see `config/dev.example.json`). Only public/publishable values may live
/// here — never a service role key or any provider access token. Those stay
/// server-side, inside Supabase Edge Functions.
class EnvConfig {
  const EnvConfig._();

  static const String supabaseUrl = String.fromEnvironment('SUPABASE_URL');

  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
  );

  static const String environmentName = String.fromEnvironment(
    'APP_ENV',
    defaultValue: 'development',
  );

  static bool get isProduction => environmentName == 'production';

  /// Skips the auth guard so the shell can be reviewed locally without a
  /// real Supabase session. Opt-in only (`--dart-define=SKIP_AUTH_FOR_DEV=true`)
  /// and additionally gated behind `kDebugMode` at the call site — never
  /// available in a release build even if this define is left on by
  /// mistake.
  static const bool skipAuthForDev = bool.fromEnvironment('SKIP_AUTH_FOR_DEV');

  /// Fails fast on startup instead of surfacing a confusing Supabase error
  /// later if the app was launched without the required dart-defines.
  static void assertValid() {
    if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
      throw StateError(
        'Missing Supabase configuration. Run the app with '
        '--dart-define-from-file=config/dev.json (copy it from '
        'config/dev.example.json and fill in your Supabase project URL and '
        'publishable/anon key).',
      );
    }
  }
}
