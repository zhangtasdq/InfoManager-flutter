import "dart:async";

import "package:flutter/material.dart";
import "package:redux/redux.dart";
import "package:flutter_redux/flutter_redux.dart";
import "package:fluttertoast/fluttertoast.dart";
import "package:local_auth/local_auth.dart";
import "package:local_auth/auth_strings.dart";
import "package:firebase_admob/firebase_admob.dart";

import "../configure/app_configure.dart";
import "../store/app_state.dart";
import "../store/app_actions.dart";
import "../mixins/i18n_mixin.dart";
import "../mixins/msg_mixin.dart";
import "../service/user_service.dart";
import "../service/app_service.dart";
import "../service/hardware_service.dart";
import "../service/shared_preference_service.dart";
import "../types.dart";

class LoginView extends StatefulWidget {
    @override
    _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with I18nMixin, MsgMixin {
    String _currentPassword;
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    int _inputErrorCount = 0;
    bool _isEnableFingerPrintUnlock = false;
    bool _isEnableDeleteFile = false;
    BannerAd _bannerAd;
    bool _isEnableAd = true;

    static final MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
        testDevices: <String>[APP_CONFIGURE["AD_DEVICE_ID"]]
    );

    BannerAd createBannerAd() {
        return BannerAd(
            adUnitId: APP_CONFIGURE["AD_MOB_AD_ID"],
            targetingInfo: targetingInfo,
            size: AdSize.smartBanner
        );
    }

    @override
    void initState() {
        super.initState();

        SharedPreferenceService.getIsEnableDeleteFile().then((isEnableDeleteFile) {
            SharedPreferenceService.getIsEnableFingerPrintUnlock().then((isEnableFingerPrintUnlock) {
                HardwareService.isSupportFingerPrint((error, {data}) {
                    setState(() {
                        _isEnableDeleteFile = isEnableDeleteFile;
                        _isEnableFingerPrintUnlock = isEnableFingerPrintUnlock && error == null && data == true;
                    });
                });
            });
        });

        if (_isEnableAd) {
            FirebaseAdMob.instance.initialize(appId: APP_CONFIGURE["AD_MOB_APP_ID"]);
            _bannerAd = createBannerAd()..load()..show(
                anchorType: AnchorType.bottom,
                anchorOffset: 0.0
            );
        }
    }

    @override
    Widget build(BuildContext context) {
        return Container(
            color: Colors.white,
            padding: EdgeInsets.only(top: 150.0, right: 32.0, left: 32.0),
            height: 300.0,
            child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                    _buildLoginPanel(context)
                ],
            )
        );
    }

    @override
    void dispose() {
        _bannerAd?.dispose();
        super.dispose();
    }

    Widget _buildLoginPanel(BuildContext context) {
        return Card(
            child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                    _buildHeader(context),
                    _buildBody(context)
                ],
            ),
        );
    }

    Widget _buildHeader(BuildContext context) {
        return Container(
            color: Colors.blue,
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Text(
                getI18nValue(context, "please_login"),
                textAlign: TextAlign.left,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0
                ),
            ),
        );
    }

    Widget _buildBody(BuildContext context) {
        return Container(
            padding: EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 40.0),
            child: Form(
                key: _formKey,
                child: Column(
                    children: <Widget>[
                        TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                                labelText: getI18nValue(context, "password"),
                                hintText: getI18nValue(context, "please_input_password"),
                            ),
                            validator: (value) {
                                if (value.isEmpty) {
                                    return getI18nValue(context, "please_input_password");
                                }
                            },

                            onSaved: (value) {
                                _currentPassword = value;
                            },

                        ),
                        Container(
                            margin: EdgeInsets.only(top: 50.0),
                            child: StoreConnector<AppState, SetPasswordActionType>(
                                converter: (store) {
                                    return (String password) {
                                        SetPasswordAction action = SetPasswordAction(password);

                                        store.dispatch(action);
                                    };
                                },
                                builder: (context, updatePasswordAction) {
                                    List<Widget> widgets = [];


                                   if (_isEnableFingerPrintUnlock) {
                                        widgets.add(
                                            RaisedButton(
                                                color: Colors.blueAccent,
                                                onPressed: () => handleFingerLogin(context, updatePasswordAction),
                                                child: Text(
                                                    getI18nValue(context, "fingerprint"),
                                                    style: TextStyle(
                                                        color: Colors.white
                                                    )
                                                ),
                                            )
                                        );
                                   }

                                    widgets.add(
                                        RaisedButton(
                                            color: Colors.blue,
                                            onPressed: () => _handleLogin(context, updatePasswordAction),
                                            child: Text(
                                                getI18nValue(context, "login"),
                                                style: TextStyle(
                                                    color: Colors.white
                                                )
                                            ),
                                        )
                                    );

                                    return Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: widgets,
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
        if (_formKey.currentState.validate()) {
            _formKey.currentState.save();

            bool loginSuccess = await UserService.login(_currentPassword);

            if (loginSuccess) {
                handleLoginSuccess(context, _currentPassword, updatePasswordAction);
            } else {
                await handlePasswordError();
            }
        }
    }

    void handleFingerLogin(BuildContext context, SetPasswordActionType updatePasswordAction) async {
        var localAuth = LocalAuthentication();

        dynamic androidStrings = AndroidAuthMessages(
            cancelButton: getI18nValue(context, "cancel"),
            goToSettingsButton: getI18nValue(context, "setting"),
            goToSettingsDescription: getI18nValue(context, "setting_fingureprint_desc"),
            fingerprintNotRecognized: getI18nValue(context, "fingerprint_not_recongnized"),
            signInTitle: getI18nValue(context, "auth_fingerprint"),
            fingerprintSuccess: getI18nValue(context, "fingerprint_auth_success")
        );

        try {
            bool didAuthenticate = await localAuth.authenticateWithBiometrics(
                localizedReason: getI18nValue(context, "please_auth_fingerprint"),
                androidAuthStrings: androidStrings,
                useErrorDialogs: false
            );

            if (didAuthenticate) {
                String password = await SharedPreferenceService.getUserPassword();
                handleLoginSuccess(context, password, updatePasswordAction);
            } else {
                await handlePasswordError();
            }
        } catch(e) {
            showToast(getI18nValue(context, "fingerprint_system_error"));
        }
    }

    Future<Null> handlePasswordError() async {
        if (_isEnableDeleteFile) {
            _inputErrorCount++;
        }

        if (_inputErrorCount == getErrorPasswordMaxCount(context)) {
            showToast(getI18nValue(context, "input_password_error_more_than_max_count"));
            await AppService.deleteFile();
        } else {
            showToast(getI18nValue(context, "password_is_error"));
        }

        return null;
    }

    void handleLoginSuccess(BuildContext context, String password,
                            SetPasswordActionType updatePasswordAction) {

        updatePasswordAction(password);


        Store<AppState> store = StoreProvider.of<AppState>(context);

        AppService.loadAppStateData(store, (error, {dynamic data}) {
            if (error != null) {
                showToast(getI18nValue(context, "load_data_error"));
            } else {
                new Future.delayed(Duration(milliseconds: 100), () {
                    store.dispatch(SetListenStoreStatusAction(true));
                    Navigator.pushReplacementNamed(context, "infoListView");
                });
            }
        });
    }

    int getErrorPasswordMaxCount(BuildContext context) {
        Store<AppState> store = getStore(context);

        return store.state.userInfo.maxErrorCount;
    }

    Store<AppState> getStore(BuildContext context) {
        return StoreProvider.of<AppState>(context);
    }
}