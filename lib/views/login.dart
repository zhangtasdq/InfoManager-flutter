import "dart:async";
import "package:flutter/material.dart";
import "package:redux/redux.dart";
import "package:flutter_redux/flutter_redux.dart";
import "package:fluttertoast/fluttertoast.dart";

import "package:info_manager/store/app_state.dart";
import "package:info_manager/store/app_actions.dart";

import "package:info_manager/mixins/i18n_mixin.dart";
import "package:info_manager/service/user_service.dart";
import "package:info_manager/service/app_service.dart";
import "package:info_manager/service/shared_preference_service.dart";

typedef void SetPasswordActionType(String password);

class LoginView extends StatefulWidget {
    @override
    _LoginViewState createState() => new _LoginViewState();
}

class _LoginViewState extends State<LoginView> with I18nMixin {
    String currentPassword;
    GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
    int inputErrorCount = 0;

    @override
    Widget build(BuildContext context) {
        return new Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 150.0, right: 10.0, left: 10.0),
            height: 300.0,
            child: new Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                    this._buildLoginPanel(context)
                ],
            )
        );
    }

    Widget _buildLoginPanel(BuildContext context) {
        return new Card(
            child: new Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                    this._buildHeader(context),
                    this._buildBody(context)
                ],
            ),
        );
    }

    Widget _buildHeader(BuildContext context) {
        return new Container(
            color: Colors.blue,
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: new Text(
                this.getI18nValue(context, "please_login"),
                textAlign: TextAlign.left,
                style: new TextStyle(
                    color: Colors.white,
                    fontSize: 18.0
                ),
            ),
        );
    }

    Widget _buildBody(BuildContext context) {
        return new Container(
            padding: EdgeInsets.fromLTRB(16.0, 20.0, 15.0, 40.0),
            child: new Form(
                key: _formKey,
                child: new Column(
                    children: <Widget>[
                        TextFormField(
                            obscureText: true,
                            decoration: new InputDecoration(

                                labelText: this.getI18nValue(context, "password"),
                                hintText: this.getI18nValue(context, "please_input_password"),
                            ),
                            validator: (value) {
                                if (value.isEmpty) {
                                    return this.getI18nValue(context, "please_input_password");
                                }
                            },

                            onSaved: (value) {
                                this.currentPassword = value;
                            },

                        ),
                        new Container(
                            margin: EdgeInsets.only(top: 50.0),
                            child: new StoreConnector<AppState, SetPasswordActionType>(
                                converter: (store) {
                                    return (String password) {
                                        SetPasswordAction action = new SetPasswordAction(password);

                                        store.dispatch(action);
                                    };
                                },
                                builder: (context, updatePasswordAction) {
                                    return new RaisedButton(
                                        color: Colors.blue,
                                        onPressed: () => this._handleLogin(context, updatePasswordAction),
                                        child: new Text(
                                            this.getI18nValue(context, "login"),
                                            style: new TextStyle(
                                                color: Colors.white
                                            )
                                        ),
                                    );
                                },
                            ),
                        ),
                    ],
                ),
            ),
        );
    }


    void _handleLogin(BuildContext context, SetPasswordActionType updatePasswordAction) async {
        if (this._formKey.currentState.validate()) {
            this._formKey.currentState.save();

            bool loginSuccess = await UserService.login(this.currentPassword);

            if (loginSuccess) {
                updatePasswordAction(this.currentPassword);


                Store<AppState> store = StoreProvider.of<AppState>(context);
                await AppService.loadAppStateData(store);


                new Future.delayed(new Duration(milliseconds: 500), () {
                    store.dispatch(new SetListenStoreStatusAction(true));
                });
                Navigator.pushReplacementNamed(context, "infoListView");
            } else {
                bool isEnableDeleteFile = await SharedPreferenceService.getIsEnableDeleteFile();

                if (isEnableDeleteFile) {
                    this.inputErrorCount++;
                }

                if (this.inputErrorCount == this.getErrorPasswordMaxCount(context)) {
                    Fluttertoast.showToast(
                        msg: this.getI18nValue(context, "input_password_error_more_than_max_count")
                    );
                    await AppService.deleteFile();
                } else {
                    Fluttertoast.showToast(
                        msg: this.getI18nValue(context, "password_is_error")
                    );
                }
            }
        }
    }

    int getErrorPasswordMaxCount(BuildContext context) {
        Store<AppState> store = this.getStore(context);

        return store.state.userInfo.maxErrorCount;
    }

    Store<AppState> getStore(BuildContext context) {
        return StoreProvider.of<AppState>(context);
    }
}