import 'package:flutter/material.dart';

import 'package:vine_habits/rally/app.dart' as rally;
import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Vine Habits',
      supportedLocales: AppLocalizations.supportedLocales,
      locale: Locale('en', 'US'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: rally.RallyApp(),
    );
  }
}
