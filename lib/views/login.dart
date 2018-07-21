import "package:flutter/material.dart";
import "package:flutter_redux/flutter_redux.dart";

import "package:info_manager/store/app_state.dart";
import "package:info_manager/store/app_actions.dart";

import "package:info_manager/mixins/i18n_mixin.dart";
import "package:info_manager/service/user_service.dart";

typedef void SetPasswordActionType(String password);

class LoginPage extends StatefulWidget {
    @override
    _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with I18nMixin {
    String currentPassword;
    GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

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
                Navigator.pushReplacementNamed(context, "infoListView");
            } else {
                new SnackBar(
                    content: new Text(
                        this.getI18nValue(context, "password_is_error"),
                        style: new TextStyle(
                            color: Colors.redAccent
                        ),
                    )
                );
            }
        }
    }
}