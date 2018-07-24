import "package:flutter/material.dart";
import "package:redux/redux.dart";
import "package:flutter_redux/flutter_redux.dart";

import "package:info_manager/store/app_actions.dart";
import "package:info_manager/store/app_state.dart";
import "package:info_manager/model/user_info.dart";
import "package:info_manager/mixins/i18n_mixin.dart";


class Setting extends StatefulWidget {
    @override
    _SettingState createState() => new _SettingState();

}

class _SettingState extends State<Setting> with I18nMixin {
    @override
    Widget build(BuildContext context) {
        return new Scaffold(
            appBar: new AppBar(
                title: new Text(this.getI18nValue(context, "setting")),
            ),
            body: this.buildBody(context),
        );
    }
    
    Widget buildBody(BuildContext context) {
        return new Container(
            child: new Column(
                children: <Widget>[
                    this.buildCommonSection(context)
                ],
            ),
        );
    }
    
    Widget buildCommonSection(BuildContext context) {
        return new Container(
            child: new Card(
                child: new Container(
                    padding: EdgeInsets.all(10.0),
                    child: new Column(
                        children: <Widget>[
                            new Row(
                                children: <Widget>[
                                    new Expanded(
                                        child: new Text(this.getI18nValue(context, "delete_file_when_password_error_more_than_5_times"))
                                    ),
                                    new StoreConnector<AppState, UserInfo>(
                                        converter: (store) {
                                            return store.state.userInfo;
                                        },
                                        builder: (context, userInfo) {
                                            return new Switch(
                                                value: userInfo.isEnableMaxErrorCount,
                                                onChanged: (bool currentValue) => this.handleToggleDeleteFileWhenPasswordError(context, currentValue)
                                            );
                                        },
                                    ),
                                ],
                            ),
                        ],
                    ),
                ),
            )
        );
    }

    void handleToggleDeleteFileWhenPasswordError(BuildContext context, bool currentValue) {
        Store<AppState> store = this.getStore(context);
        ToggleDeleteFileWhenPasswordErrorAction action = new ToggleDeleteFileWhenPasswordErrorAction(currentValue);

        setState(() {
            store.dispatch(action);
        });
    }

    Store<AppState> getStore(BuildContext context) {
        return StoreProvider.of<AppState>(context);
    }
}