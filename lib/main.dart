import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:vine_habits/rally/app.dart' as rally;
import 'package:flutter_gen/gen_l10n/gallery_localizations.dart';
import 'package:vine_habits/data/gallery_options.dart';
import 'package:vine_habits/themes/gallery_theme_data.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ModelBinding(
      initialModel: GalleryOptions(
        themeMode: ThemeMode.system,
        textScaleFactor: 1,
        customTextDirection: CustomTextDirection.localeBased,
        locale: const Locale('en', 'US'),
        platform: defaultTargetPlatform,
        isTestMode: false,
      ),
      child: Builder(builder: (context) {
        final options = GalleryOptions.of(context);

        return MaterialApp(
          restorationScopeId: 'rally_app',
          title: 'Vine Habits',
          debugShowCheckedModeBanner: false,
          themeMode: options.themeMode,
          theme: GalleryThemeData.lightThemeData.copyWith(
            platform: options.platform,
          ),
          darkTheme: GalleryThemeData.darkThemeData.copyWith(
            platform: options.platform,
          ),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: GalleryOptions.of(context).locale,
          home: const rally.RallyApp(),
        );
      }),
    );
  }
}
