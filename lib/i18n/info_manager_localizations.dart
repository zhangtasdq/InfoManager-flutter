import "dart:async";
import "package:flutter/material.dart";
import "package:flutter/foundation.dart" show SynchronousFuture;

import "package:info_manager/i18n/zh.dart";
import "package:info_manager/i18n/en.dart";

class InfoManagerLocalizations {
    final Locale locale;

    InfoManagerLocalizations(this.locale);

    static InfoManagerLocalizations of(BuildContext context) {
        return Localizations.of<InfoManagerLocalizations>(context, InfoManagerLocalizations);
    }

    static Map<String, Map<String, String>> _localizedValues = {
        "en": EN,
        "zh": ZH
    };


    String getI18nValue(String key) {
        return _localizedValues[locale.languageCode][key];
    }
}

class InfoManagerLocalizationsDelegate extends LocalizationsDelegate<InfoManagerLocalizations> {
    const InfoManagerLocalizationsDelegate();

    @override
    bool isSupported(Locale locale) {
        return ['en', 'zh'].contains(locale.languageCode);
    }

    @override
    Future<InfoManagerLocalizations> load(Locale locale) {
        return SynchronousFuture<InfoManagerLocalizations>(InfoManagerLocalizations(locale));
    }

    @override
    bool shouldReload(InfoManagerLocalizationsDelegate old) {
        return false;
    }
}
