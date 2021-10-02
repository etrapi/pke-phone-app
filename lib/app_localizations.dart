import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

class AppLocalizations {
  final String localeName;

  AppLocalizations(this.localeName);

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  YamlMap translations;
  YamlMap translationsFallback;

  Future load() async {
    String yamlString = await rootBundle.loadString('lang/$localeName.yml');
    translations = loadYaml(yamlString);

    String yamlString1 = await rootBundle.loadString('lang/en.yml');
    translationsFallback = loadYaml(yamlString1);
  }

  dynamic t(String key) {
    try {
      var keys = key.split(".");
      dynamic translated = translations;
      keys.forEach((k) => translated = translated[k]);

      if (translated == null) {
        return _fallback(key);
      }
      return translated;
    } catch (e) {
      return _fallback(key);
    }
  }

  dynamic _fallback(String key) {
    try {
      var keys = key.split(".");
      dynamic translated = translationsFallback;
      keys.forEach((k) => translated = translated[k]);

      if (translated == null) {
        return "Key not found....: $key";
      }
      return translated;
    } catch (e) {
      return "Key not found: $key";
    }
  }

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(
        context, AppLocalizations);
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    print(locale.languageCode);
    return ['es', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    var t = AppLocalizations(locale.languageCode);
    await t.load();
    return t;
  }

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) {
    return false;
  }
}
