import "package:redux/redux.dart";
import "package:flutter_redux/flutter_redux.dart";
import "package:flutter/material.dart";

import "package:info_manager/mixins/i18n_mixin.dart";
import "package:info_manager/store/app_state.dart";
import "package:info_manager/service/shared_preference_service.dart";
import "../service/hardware_service.dart";
import "../mixins/msg_mixin.dart";


class SettingView extends StatefulWidget {
    @override
    _SettingViewState createState() => new _SettingViewState();

}

class _SettingViewState extends State<SettingView> with I18nMixin, MsgMixin {
    bool isEnableDeleteFile = false;
    bool isEnableFingerprintUnlock = false;
    bool isShowFingerprintUnlock;

    @override
    void initState() {
        super.initState();
        SharedPreferenceService.getIsEnableDeleteFile().then((isEnableDeleteFile) {
            SharedPreferenceService.getIsEnableFingerPrintUnlock().then((isEnableFingerprintUnlock) {
                setState(() {
                    this.isEnableDeleteFile = isEnableDeleteFile;
                    this.isEnableFingerprintUnlock = isEnableFingerprintUnlock;
                });

            });
        });

    }

    @override
    Widget build(BuildContext context) {
        if (this.isShowFingerprintUnlock == null) {
            HardwareService.isSupportFingerPrint((error, {data}) {
                if (error != null){
                    this.showToast(this.getI18nValue(context, "system_error"));
                } else {
                    setState(() {
                        this.isShowFingerprintUnlock = data;
                    });
                }
            });
        }
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
        List<Widget> widgets = <Widget>[];

        widgets.add(
            Row(
                children: <Widget>[
                    Expanded(
                        child: Text(this.getI18nValue(context, "delete_file_when_password_error_more_than_5_times"))
                    ),
                    Switch(
                        value: this.isEnableDeleteFile,
                        onChanged: (bool currentValue) => this.handleToggleDeleteFileWhenPasswordError(currentValue)
                    ),
                ],
            ),
        );

        if (this.isShowFingerprintUnlock == true) {
            widgets.add(
                Row(
                    children: <Widget>[
                        Expanded(
                            child: Text(this.getI18nValue(context, "is_enable_fingerprint unlock"))
                        ),
                        Switch(
                            value: this.isEnableFingerprintUnlock,
                            onChanged: (bool currentValue) => this.handleToggleFingerPrintUnlock(context, currentValue)
                        ),
                    ],
                )

            );
        }

        return new Container(
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
            this.isEnableDeleteFile = currentValue;
        });
    }

    void handleToggleFingerPrintUnlock(BuildContext context, bool currentValue) async {
        BuildContext topContext = context;
        if (currentValue == true) {
            showDialog(
                context: context,
                builder: (context) {
                    return AlertDialog(
                        content: Text(this.getI18nValue(context, "confirm_enable_fingerprint_msg")),
                        actions: <Widget>[
                            RaisedButton(
                                child: Text(this.getI18nValue(context, "cancel")),
                                onPressed: () => Navigator.of(context).pop()
                            ),
                            RaisedButton(
                                child: Text(this.getI18nValue(context, "confirm")),
                                onPressed: () {
                                    Navigator.of(context).pop();
                                    this.toggleEnableFingerPrintValue(topContext, currentValue);
                                },
                            )
                        ],
                    );
                }
            );

        } else {
            this.toggleEnableFingerPrintValue(context, currentValue);
        }
    }

    void toggleEnableFingerPrintValue(BuildContext context, bool currentValue) async {
        bool result = await SharedPreferenceService.setIsEnableFingerPrintUnlock(currentValue);

        if (result) {
            bool saveResult = false;
            if (currentValue) {
                Store<AppState> store = this.getStore(context);
                saveResult = await SharedPreferenceService.setUserPassword(store.state.userInfo.getPassword());
            } else {
                saveResult = await SharedPreferenceService.removeUserPassword();
            }

            if (saveResult) {
                setState(() {
                    this.isEnableFingerprintUnlock = currentValue;
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