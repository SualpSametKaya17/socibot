import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app/app.dart';
import 'core/services/supabase/supabase_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inter's regular/medium/semibold weights are bundled locally (see
  // pubspec.yaml's assets and assets/fonts/) — this stops google_fonts
  // from ever attempting a runtime fetch from fonts.gstatic.com, which
  // throws in network-restricted environments (sandboxes, some
  // corporate networks) instead of just falling back quietly.
  GoogleFonts.config.allowRuntimeFetching = false;

  await SupabaseService.initialize();

  runApp(const ProviderScope(child: SocibotApp()));
}
