import 'package:supabase_flutter/supabase_flutter.dart';

import '../../constants/env_config.dart';

/// Thin wrapper around Supabase initialization.
///
/// The Flutter client is only ever configured with the publishable/anon key
/// (see [EnvConfig]). Anything requiring elevated privileges — provider
/// tokens, the service role key, ERP credentials — must go through a
/// Supabase Edge Function instead.
class SupabaseService {
  const SupabaseService._();

  static Future<void> initialize() async {
    EnvConfig.assertValid();

    await Supabase.initialize(
      url: EnvConfig.supabaseUrl,
      publishableKey: EnvConfig.supabaseAnonKey,
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
