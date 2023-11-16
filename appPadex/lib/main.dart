import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ColorCategory.dart';
import 'HomeWidget.dart';
import 'SplashScreen.dart';
import 'generated/l10n.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // MobileAds.instance.initialize();
  // ignore: invalid_use_of_visible_for_testing_member
  SharedPreferences.setMockInitialValues({});
  runApp(
    MyApp(),
  );
  // runApp(MyApp());
}

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  ThemeData themeData = new ThemeData(
    primaryColor: primaryColor,
    primaryColorDark: primaryColor,

    // accentColor: accentColor,

    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: accentColor, // Your accent color
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        S.delegate
      ],

      supportedLocales: S.delegate.supportedLocales,
      // locale: new Locale(setLocals, ''),
      title: 'Flutter Demo',
      theme: themeData,
      home: SplashScreen(),
      // home: IntroScreen(),
    );
  }
}

class MyHomeApp extends StatefulWidget {
  @override
  _MyHomeApp createState() => _MyHomeApp();
}

class _MyHomeApp extends State<MyHomeApp> {
  // This widget is the root of your application.
  ThemeData themeData = new ThemeData(
    primaryColor: primaryColor,
    primaryColorDark: primaryColor,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: accentColor, // Your accent color
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [S.delegate],
      supportedLocales: S.delegate.supportedLocales,
      // locale: new Locale(setLocals, ''),
      title: 'Flutter Demo',
      theme: themeData,
      // home: IntroScreen(),
      home: HomeWidget(0),
      // home: MyHomePage(),
    );
  }
}
