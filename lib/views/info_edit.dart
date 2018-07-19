import "package:flutter/material.dart";

import "package:info_manager/util/uid.dart";

import "package:info_manager/mixins/i18n_mixin.dart";
import "package:info_manager/model/info.dart";
import "package:info_manager/model/category.dart";
import "package:info_manager/model/info_detail.dart";

class InfoEditPage extends StatefulWidget {
    final String viewAction;

    InfoEditPage(this.viewAction);

    @override
    _InfoEditPageState createState() => new _InfoEditPageState(this.viewAction);
}

class _InfoEditPageState extends State<InfoEditPage> with I18nMixin {
    String _viewAction;
    Info _currentInfo;
    GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

    _InfoEditPageState(this._viewAction) {
        this.setInitData();
    }

    @override
    Widget build(BuildContext context) {
        return new Scaffold(
            appBar: this.buildHeader(context),
            body: this.buildBody(context)
        );
    }

    @override
    void dispose() {
        super.dispose();
    }

    Widget buildHeader(BuildContext context) {
        List<Widget> actions = new List();

        if (this.isEdit()) {
            actions.add(
                new IconButton(
                    icon: new Icon(
                        Icons.delete,
                        color: Colors.white
                    ),
                    onPressed: this.handleClickDelete
                )
            );
        }

        actions.add(
            new IconButton(
                icon: new Icon(
                    Icons.save,
                    color: Colors.white
                ),
                onPressed: this.handleClickSave
            )
        );

        return new AppBar(
            title: new Text(this.getTitleStr(context)),
            actions: actions,
        );
    }

    Widget buildBody(BuildContext context) {
        return new Container(
            padding: EdgeInsets.only(bottom: 10.0, top: 10.0, left: 10.0, right: 10.0),
            child: new Form(
                key: _formKey,
                child: new ListView.builder(
                    itemCount: this.getListItemCount(),
                    itemBuilder: (context, i) {
                        if (i == 0) {
                            return this.buildMainInfoItem(context);
                        }

                        if (this.getListItemCount() - 1 == i ) {
                            return this.buildAddBtn(context);
                        }

                        return this.buildInfoDetailItem(context, i);
                    }
                )
            ),
        );
    }

    int getListItemCount() {
        return this._currentInfo.getDetailCount() + 2;
    }

    Widget buildMainInfoItem(BuildContext context) {
        return new Card(
            child: new Container(
                padding: EdgeInsets.all(10.0),
                child: new Column(
                    children: <Widget>[
                        TextFormField(
                            decoration: new InputDecoration(
                                labelText: this.getI18nValue(context, "title"),
                                hintText: this.getI18nValue(context, "please_input_title"),
                            ),
                            validator: (value) {
                                if (value.isEmpty) {
                                    return this.getI18nValue(context, "title_can_not_empty");
                                }
                            },
                            onSaved: (value) {
                                this._currentInfo.setTitle(value);
                            },
                        ),
                        new TextField(
                            decoration: new InputDecoration(
                                labelText: this.getI18nValue(context, "category"),
                                hintText: this.getI18nValue(context, "please_select_category"),
                            ),
                        ),
                    ],
                ),
            ),
        );
    }

    Widget buildInfoDetailItem(BuildContext context, int index) {
        int detailIndex = index - 1;
        InfoDetail item = this._currentInfo.findDetailByIndex(detailIndex);

        return new Card(
            child: new Container(
                padding: EdgeInsets.all(10.0),
                child: new Column(
                    children: <Widget>[
                        TextFormField(
                            decoration: new InputDecoration(
                                labelText: this.getI18nValue(context, "property"),
                                hintText: this.getI18nValue(context, "please_input_property"),
                            ),
                            validator: (value) {
                                if (value.isEmpty) {
                                    return this.getI18nValue(context, "property_can_not_empty");
                                }
                            },
                            onSaved: (value) {
                                item.setPropertyName(value);
                            },

                        ),

                        new Row(
                            children: <Widget>[
                                new Expanded(
                                    child: new TextFormField(
                                        decoration: new InputDecoration(
                                            labelText: this.getI18nValue(context, "content"),
                                            hintText: this.getI18nValue(context, "please_input_content"),
                                        ),
                                        validator: (value) {
                                            if (value.isEmpty) {
                                                return this.getI18nValue(context, "content_can_not_empty");
                                            }
                                        },
                                        onSaved: (value) {
                                            item.setPropertyValue(value);
                                        },
                                    ),
                                ),
                                new Padding(
                                    padding: EdgeInsets.only(top: 35.0),
                                    child: new Checkbox(
                                        value: item.isHide(),
                                        onChanged: (bool checked) => this.handleClickHideCheckbox(item, checked)
                                    ),
                                ),
                                new Padding(
                                    padding: EdgeInsets.only(top: 35.0),
                                    child: new Text("hide")
                                )
                            ],
                        )
                    ],
                ),
            ),
        );
    }

    Widget buildAddBtn(BuildContext context) {
        return new Container(
            margin: EdgeInsets.only(top: 30.0),
            child: new RaisedButton(
                onPressed: this.handleClickAddDetailItem,
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: new Icon(
                    Icons.add,
                    size: 30.0,
                    color: Colors.blue,
                ),
            )
        );
    }

    String getTitleStr(BuildContext context) {
        if (this.isEdit()) {
            return this.getI18nValue(context, "edit_info");
        }
        return this.getI18nValue(context, "create_info");

    }

    bool isEdit() {
        return this._viewAction == "edit";
    }

    void setInitData() {
        this._currentInfo = new Info(Uid.generateUid(), "", "", []);
    }
    
    void handleClickHideCheckbox(InfoDetail item, bool checked) {
        setState(() {
            item.setIsHide(checked);
        });
    }

    void handleClickAddDetailItem() {
        setState(() {
            this._currentInfo.addEmptyDetailItem();
        });
    }


    void handleClickSave() {
        if (_formKey.currentState.validate()) {
            _formKey.currentState.save();
            print(this._currentInfo.toString());
        }
    }

    void handleClickDelete() {

    }
}