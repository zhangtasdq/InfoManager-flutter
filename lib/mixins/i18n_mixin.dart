import "package:flutter/material.dart";

import "package:info_manager/i18n/info_manager_localizations.dart" show InfoManagerLocalizations;

class I18nMixin {
    String getI18nValue(BuildContext context, String key) {
        return InfoManagerLocalizations.of(context).getI18nValue(key);
    }
}