// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Pantalla Principal',
      name: 'Pantalla Principal',
      desc: '',
      args: [],
    );
  }

  /// `Home Workouts`
  String get homeWorkouts {
    return Intl.message(
      'Pantalla Entrenamientos',
      name: 'Pantalla Entrenamientos',
      desc: '',
      args: [],
    );
  }

  /// `Discover`
  String get discover {
    return Intl.message(
      'Descubrir',
      name: 'Descubrir',
      desc: '',
      args: [],
    );
  }

  /// `Activity`
  String get activity {
    return Intl.message(
      'Actividad',
      name: 'Actividad',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Configuraciones',
      name: 'Configuraciones',
      desc: '',
      args: [],
    );
  }

  /// `Transformation`
  String get transformation {
    return Intl.message(
      'Transformación',
      name: 'Transformación',
      desc: '',
      args: [],
    );
  }

  /// `Beginner`
  String get beginner {
    return Intl.message(
      'Principiante',
      name: 'Principiante',
      desc: '',
      args: [],
    );
  }

  /// `Challenges`
  String get challenges {
    return Intl.message(
      'Desafios',
      name: 'Desafios',
      desc: '',
      args: [],
    );
  }

  /// `Minutes`
  String get minutes {
    return Intl.message(
      'Minutos',
      name: 'Minutos',
      desc: '',
      args: [],
    );
  }

  /// `Kcal`
  String get kcal {
    return Intl.message(
      'Kcal',
      name: 'kcal',
      desc: '',
      args: [],
    );
  }

  /// `Workouts`
  String get workouts {
    return Intl.message(
      'Entrenamientos',
      name: 'Entrenamientos',
      desc: '',
      args: [],
    );
  }

  /// `Week`
  String get week {
    return Intl.message(
      'Semana',
      name: 'Semana',
      desc: '',
      args: [],
    );
  }

  /// `Intermediate`
  String get intermediate {
    return Intl.message(
      'Intermedio',
      name: 'Intermedio',
      desc: '',
      args: [],
    );
  }

  /// `Advanced`
  String get advanced {
    return Intl.message(
      'Avanzado',
      name: 'Avanzado',
      desc: '',
      args: [],
    );
  }

  /// `Calories`
  String get calories {
    return Intl.message(
      'Calorias',
      name: 'Calorias',
      desc: '',
      args: [],
    );
  }

  /// `Seconds`
  String get seconds {
    return Intl.message(
      'Segundos',
      name: 'Segundos',
      desc: '',
      args: [],
    );
  }

  /// `Quick Workouts`
  String get quickWorkouts {
    return Intl.message(
      'Entrenamientos Rapidos',
      name: 'Entrenamientos Rapidos',
      desc: '',
      args: [],
    );
  }

  /// `Popular Workouts`
  String get popularWorkouts {
    return Intl.message(
      'Entrenamientos Populares',
      name: 'Entrenamientos Populares',
      desc: '',
      args: [],
    );
  }

  /// `Top Picks`
  String get topPicks {
    return Intl.message(
      'Los más escogidos',
      name: 'Los más escogidos',
      desc: '',
      args: [],
    );
  }

  /// `Stretches`
  String get stretches {
    return Intl.message(
      'Estiramientos',
      name: 'Estiramientos',
      desc: '',
      args: [],
    );
  }

  /// `GO`
  String get go {
    return Intl.message(
      'Vamos',
      name: 'Vamos',
      desc: '',
      args: [],
    );
  }

  /// `Exercises`
  String get exercises {
    return Intl.message(
      'Ejercicios',
      name: 'Ejercicios',
      desc: '',
      args: [],
    );
  }

  /// `WORKOUT`
  String get workout {
    return Intl.message(
      'Entrenamientos',
      name: 'Entrenamientos',
      desc: '',
      args: [],
    );
  }

  /// `Workout`
  String get app_name {
    return Intl.message(
      'PDX GYM',
      name: 'PDX GYM',
      desc: '',
      args: [],
    );
  }

  String get intro_desc_1 {
    return Intl.message(
      'Aqui van las instrucciones por ejercicio.',
      name: 'intro_desc_1',
      desc: '',
      args: [],
    );
  }

  String get intro_desc_2 {
    return Intl.message(
      'Aqui van las instrucciones por ejercicio.',
      name: 'intro_desc_2',
      desc: '',
      args: [],
    );
  }

  String get intro_desc_3 {
    return Intl.message(
      'Aqui van las instrucciones por ejercicio.',
      name: 'intro_desc_3',
      desc: '',
      args: [],
    );
  }

  /// `Workout`
  String get workout_small {
    return Intl.message(
      'Entrenamiento Rápido',
      name: 'Entrenamiento Rápido',
      desc: '',
      args: [],
    );
  }

  /// `Shape Your Body`
  String get shapeYourBody {
    return Intl.message(
      'Moldea tu cuerpo',
      name: 'Moldea tu cuerpo',
      desc: '',
      args: [],
    );
  }

  /// `build muscle, get toned, achive an athlet's body`
  String get buildMuscleGetTonedAchiveAnAthletsBody {
    return Intl.message(
      'trabajar musculos, tonificar, obtener un cuerpo atletico',
      name: 'trabajar musculos, tonificar, obtener un cuerpo atletico',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
