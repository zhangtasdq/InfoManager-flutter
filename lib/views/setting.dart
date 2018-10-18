import "package:redux/redux.dart";
import "package:flutter_redux/flutter_redux.dart";
import "package:flutter/material.dart";

import "../mixins/i18n_mixin.dart";
import "../mixins/msg_mixin.dart";
import "../store/app_state.dart";
import "../service/shared_preference_service.dart";
import "../service/hardware_service.dart";

class SettingView extends StatefulWidget {
    @override
    _SettingViewState createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> with I18nMixin, MsgMixin {
    bool _isEnableDeleteFile = false;
    bool _isEnableFingerprintUnlock = false;
    bool _isShowFingerprintUnlock;

    @override
    void initState() {
        super.initState();

        SharedPreferenceService.getIsEnableDeleteFile().then((isEnableDeleteFile) {
            SharedPreferenceService.getIsEnableFingerPrintUnlock().then((isEnableFingerprintUnlock) {
                setState(() {
                    _isEnableDeleteFile = isEnableDeleteFile;
                    _isEnableFingerprintUnlock = isEnableFingerprintUnlock;
                });

            });
        });
    }

    @override
    Widget build(BuildContext context) {
        if (_isShowFingerprintUnlock == null) {
            HardwareService.isSupportFingerPrint((error, {data}) {
                if (error != null){
                    showToast(getI18nValue(context, "system_error"));
                } else {
                    setState(() {
                        _isShowFingerprintUnlock = data;
                    });
                }
            });
        }
        return Scaffold(
            appBar: AppBar(
                title: Text(getI18nValue(context, "setting")),
            ),
            body: buildBody(context),
        );
    }

    Widget buildBody(BuildContext context) {
        return Container(
            child: Column(
                children: <Widget>[
                    buildCommonSection(context)
                ],
            ),
        );
    }

    Widget buildCommonSection(BuildContext context) {
        List<Widget> widgets = <Widget>[];

        widgets.add(
            Row(
                children: <Widget>[
                    Expanded(
                        child: Text(getI18nValue(context, "delete_file_when_password_error_more_than_5_times"))
                    ),
                    Switch(
                        value: _isEnableDeleteFile,
                        onChanged: (bool currentValue) => handleToggleDeleteFileWhenPasswordError(currentValue)
                    ),
                ],
            ),
        );

        if (_isShowFingerprintUnlock == true) {
            widgets.add(
                Row(
                    children: <Widget>[
                        Expanded(
                            child: Text(getI18nValue(context, "is_enable_fingerprint unlock"))
                        ),
                        Switch(
                            value: _isEnableFingerprintUnlock,
                            onChanged: (bool currentValue) => handleToggleFingerPrintUnlock(context, currentValue)
                        ),
                    ],
                )

            );
        }

        return Container(
            child: Card(
                child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                        children: widgets
                    ),
                ),
            )
        );
    }

    void handleToggleDeleteFileWhenPasswordError(bool currentValue) async {
        await SharedPreferenceService.setIsEnableDeleteFile(currentValue);
        setState(() {
            _isEnableDeleteFile = currentValue;
        });
    }

    void handleToggleFingerPrintUnlock(BuildContext context, bool currentValue) async {
        BuildContext topContext = context;

        if (currentValue == true) {
            showDialog(
                context: context,
                builder: (context) {
                    return AlertDialog(
                        content: Text(getI18nValue(context, "confirm_enable_fingerprint_msg")),
                        actions: <Widget>[
                            RaisedButton(
                                child: Text(getI18nValue(context, "cancel")),
                                onPressed: () => Navigator.of(context).pop()
                            ),
                            RaisedButton(
                                child: Text(getI18nValue(context, "confirm")),
                                onPressed: () {
                                    Navigator.of(context).pop();
                                    toggleEnableFingerPrintValue(topContext, currentValue);
                                },
                            )
                        ],
                    );
                }
            );
        } else {
            toggleEnableFingerPrintValue(context, currentValue);
        }
    }

    void toggleEnableFingerPrintValue(BuildContext context, bool currentValue) async {
        bool result = await SharedPreferenceService.setIsEnableFingerPrintUnlock(currentValue);

        if (result) {
            bool saveResult = false;
            if (currentValue) {
                Store<AppState> store = getStore(context);
                saveResult = await SharedPreferenceService.setUserPassword(store.state.userInfo.password);
            } else {
                saveResult = await SharedPreferenceService.removeUserPassword();
            }

            if (saveResult) {
                setState(() {
                    _isEnableFingerprintUnlock = currentValue;
                });
            } else {
                await SharedPreferenceService.setIsEnableFingerPrintUnlock(!currentValue);
            }
        }
    }

    Store<AppState> getStore(BuildContext context) {
        return StoreProvider.of<AppState>(context);
    }
}