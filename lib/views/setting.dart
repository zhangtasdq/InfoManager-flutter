import "package:flutter/material.dart";
import "package:info_manager/mixins/i18n_mixin.dart";
import "package:info_manager/service/shared_preference_service.dart";


class SettingView extends StatefulWidget {
    @override
    _SettingViewState createState() => new _SettingViewState();

}

class _SettingViewState extends State<SettingView> with I18nMixin {
    bool isEnableDeleteFile = false;

    @override
    void initState() {
        super.initState();
        SharedPreferenceService.getIsEnableDeleteFile().then((value) {
            setState(() {
                this.isEnableDeleteFile = value;
            });
        });
    }

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
                                    new Switch(
                                        value: this.isEnableDeleteFile,
                                        onChanged: (bool currentValue) => this.handleToggleDeleteFileWhenPasswordError(context, currentValue)
                                    ),
                                ],
                            ),
                        ],
                    ),
                ),
            )
        );
    }

    void handleToggleDeleteFileWhenPasswordError(BuildContext context, bool currentValue) async {
        await SharedPreferenceService.setIsEnableDeleteFile(currentValue);
        setState(() {
            this.isEnableDeleteFile = currentValue;
        });
    }
}