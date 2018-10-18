import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:flutter/rendering.dart";
import "package:redux/redux.dart";
import "package:flutter_redux/flutter_redux.dart";

import "./store/app_actions.dart";
import "./store/app_state.dart";
import "./store/app_reducer.dart";
import "./i18n/info_manager_localizations.dart" show InfoManagerLocalizationsDelegate;
import "./service/app_service.dart";
import "./views/login.dart";
import "./views/info_list.dart";
import "./views/setting.dart";
import "./views/category_list.dart";

void main() {
    runApp(InfoManager());
}

class InfoManager extends StatefulWidget {
    @override
    _InfoManagerState createState() => _InfoManagerState();
}

class _InfoManagerState extends State<InfoManager> with WidgetsBindingObserver {
    bool _previousInitState = false;
    Store<AppState> _store;
    BuildContext _appContext;

    @override
    void initState() {
        super.initState();
        _store = Store<AppState>(
            appReducer,
            initialState: new AppState(),
        );
        _store.onChange.listen(handleStateChange);
        WidgetsBinding.instance.addObserver(this);
    }

    @override
    void dispose() {
        WidgetsBinding.instance.removeObserver(this);
        super.dispose();
    }

    @override
    void didChangeAppLifecycleState(AppLifecycleState state) {
        if (state == AppLifecycleState.paused) {
            handleAppPause();
        }
    }

    @override
    Widget build(BuildContext context) {
        return StoreProvider(
            store: _store,
            child: MaterialApp(
                title: "InfoManager",
                theme: ThemeData(
                    primaryColor: Colors.blue
                ),
                home: Builder(
                    builder: (context) {
                        _appContext = context;
                        return LoginView();
                    }
                ),
                localizationsDelegates: [
                    const InfoManagerLocalizationsDelegate(),
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate
                ],
                supportedLocales: [
                    const Locale("en", ""),
                    const Locale("zh", "")
                ],
                routes: {
                    "loginView": (BuildContext context) => LoginView(),
                    "infoListView": (BuildContext context) {
                        _appContext = context;
                        return InfoListView();
                    },
                    "settingView": (BuildContext context) => SettingView(),
                    "categoryListView": (BuildContext context) => CategoryListView()
                },
            )
        );
    }

    void handleStateChange(AppState state) async {
        if (shouldSaveAppState(state)) {
            await AppService.saveAppStateData(state);
        }
    }

    void handleAppPause() {
        ResetAppAction action = ResetAppAction();
        _store.dispatch(action);
        Navigator.of(_appContext).pushNamedAndRemoveUntil("loginView", (Route<dynamic> route) => false);
    }

    bool shouldSaveAppState(AppState state) {
        if (!state.isListen) {
            return false;
        }

        if (!_previousInitState) {
            _previousInitState = true;
            return false;
        }
        return true;
    }
}