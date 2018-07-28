import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:flutter_localizations/flutter_localizations.dart";
import "package:flutter/rendering.dart";
import "package:redux/redux.dart";
import "package:flutter_redux/flutter_redux.dart";

import "package:info_manager/store/app_actions.dart";
import "package:info_manager/store/app_state.dart";
import "package:info_manager/store/app_reducer.dart";

import "package:info_manager/i18n/info_manager_localizations.dart" show InfoManagerLocalizationsDelegate;
import "package:info_manager/service/app_service.dart";

import "package:info_manager/views/login.dart";
import "package:info_manager/views/info_list.dart";
import "package:info_manager/views/setting.dart";
import "package:info_manager/views/category_list.dart";

void main() {
    runApp(new InfoManager());
}

class InfoManager extends StatefulWidget {
    @override
    _InfoManagerState createState() => new _InfoManagerState();
}

class _InfoManagerState extends State<InfoManager> with WidgetsBindingObserver {
    bool previousInitState = false;
    Store<AppState> store;
    BuildContext appContext;

    @override
    void initState() {
        super.initState();
        store = new Store<AppState>(
            appReducer,
            initialState: new AppState(),
        );
        store.onChange.listen(this.handleStateChange);
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
            this.handleAppPause();
        }
    }


    @override
    Widget build(BuildContext context) {
        return new StoreProvider(
            store: store,
            child: new MaterialApp(
                title: "InfoManager",
                theme: new ThemeData(
                    primaryColor: Colors.blue
                ),
                home: Builder(
                    builder: (context) {
                        this.appContext = context;
                        return new LoginView();
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
                    "loginView": (BuildContext context) => new LoginView(),
                    "infoListView": (BuildContext context) {
                        this.appContext = context;
                        return new InfoListView();
                    },
                    "settingView": (BuildContext context) => new SettingView(),
                    "categoryListView": (BuildContext context) => new CategoryListView()
                },
            )
        );
    }

    void handleStateChange(AppState state) async {
        if (this.shouldSaveAppState(state)) {
            await AppService.saveAppStateData(state);
        }
    }

    void handleAppPause() {
        ResetAppAction action = new ResetAppAction();
        this.store.dispatch(action);
        Navigator.of(this.appContext).pushNamedAndRemoveUntil("loginView", (Route<dynamic> route) => false);
    }

    bool shouldSaveAppState(AppState state) {
        if (!state.isListen) {
            return false;
        }

        if (!previousInitState) {
            previousInitState = true;
            return false;
        }
        return true;
    }
}