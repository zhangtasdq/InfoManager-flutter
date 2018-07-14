import "package:flutter/material.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:flutter/rendering.dart";

import "package:info_manager/i18n/info_manager_localizations.dart" show InfoManagerLocalizationsDelegate;

import "package:info_manager/views/login.dart";

void main() {
    runApp(new InfoManager());
}

class InfoManager extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
        return new MaterialApp(
            title: "12",
            theme: new ThemeData(
                primaryColor: Colors.blue
            ),
            home: new LoginPage(),
            localizationsDelegates: [
                const InfoManagerLocalizationsDelegate(),
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate
            ],
            supportedLocales: [
                const Locale("en", ""),
                const Locale("zh", "")
            ],
        );
    }
}