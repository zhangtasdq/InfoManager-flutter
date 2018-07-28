import "dart:async";
import "package:flutter/material.dart";
import "package:redux/redux.dart";
import "package:flutter_redux/flutter_redux.dart";
import "package:fluttertoast/fluttertoast.dart";

import "package:info_manager/store/app_state.dart";
import "package:info_manager/store/app_actions.dart";
import "package:info_manager/util/uid.dart";
import "package:info_manager/mixins/i18n_mixin.dart";
import "package:info_manager/model/info.dart";
import "package:info_manager/model/category.dart";
import "package:info_manager/model/info_detail.dart";
import "../components/category_select_list.dart";
import "../components/add_category_dialog.dart";

typedef void AddCategoryActionType(Category category);

class InfoEditView extends StatefulWidget {
    final String viewAction;
    final String editInfoId;

    InfoEditView(this.viewAction, [this.editInfoId]);

    @override
    _InfoEditViewState createState() => new _InfoEditViewState(this.viewAction, this.editInfoId);
}

class _InfoEditViewState extends State<InfoEditView> with I18nMixin {
    bool _isInit = false;
    String _viewAction;
    String _editInfoId;
    Info _currentInfo;
    GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
    TextEditingController _selectCategoryController;

    _InfoEditViewState(this._viewAction, [this._editInfoId]);

    @override
    void initState() {
        super.initState();
        this._selectCategoryController = TextEditingController();
    }

    @override
    void dispose() {
        this._selectCategoryController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        if (this._isInit == false) {
            this.setInitData(context);
            this._isInit = true;
        }
        return new Scaffold(
            appBar: this.buildHeader(context),
            body: this.buildBody(context)
        );
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
                    onPressed: () => this.handleClickDelete(context)
                )
            );
        }

        actions.add(
            new IconButton(
                icon: new Icon(
                    Icons.save,
                    color: Colors.white
                ),
                onPressed: () => this.handleClickSave(context)
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
                            initialValue: this._currentInfo.title,
                        ),
                        GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            child: TextFormField(
                                controller: this._selectCategoryController,
                                decoration: InputDecoration(
                                    labelText: this.getI18nValue(context, "category"),
                                    labelStyle: DefaultTextStyle.of(context).style,
                                    enabled: false,
                                    suffixIcon: Icon(
                                        Icons.arrow_drop_down
                                    )
                                ),
                            ),
                            onTap: () => this.showCategorySelectDialog(context)
                            
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
                padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                child: new Stack(children: <Widget>[
                    new Positioned(
                        child: new IconButton(
                            icon: new Icon(Icons.close, color: Colors.red,),
                            onPressed: () => this.handleDeleteInfoDetailItem(detailIndex)
                        ),
                        top: 0.0,
                        right: 0.0,
                    ),
                    new Container(
                        margin: EdgeInsets.only(top: 25.0),
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
                                    initialValue: item.propertyName,

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
                                                initialValue: item.propertyValue,
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
                                            child: new Text(this.getI18nValue(context, "hide"))
                                        )
                                    ],
                                )
                            ],
                        ),
                    ),

                ],),
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

    void setInitData(BuildContext context) {
        if (this.isEdit()) {
            this._currentInfo = this.getCurrentInfo(context).clone();
        } else {
            this._currentInfo = new Info(Uid.generateUid(), "", "", []);
        }
    }

    void showCategorySelectDialog(BuildContext context) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
                return AlertDialog(
                    title: Container(
                        child: Row(
                            children: <Widget>[
                                Expanded(
                                    child: new Text(this.getI18nValue(context, "select_category")),
                                ),
                                IconButton(
                                    icon: Icon(Icons.add, size: 32.0),
                                    onPressed: () => this.handleCreateCategory(context),
                                )
                            ],
                        ),
                    ),
                    content: Container(
                        height: 300.0,
                        child: CategorySelectList(
                            checkedItem: this._currentInfo.categoryId,
                            onPress: (dynamic item) {
                                this.handleSelectCategory(context, item);
                            },
                        ),
                    ),
                );
            }
        );
        
    }

    void handleDeleteInfoDetailItem(int index) {
        setState(() {
            this._currentInfo.removeDetailItemByIndex(index);
        });
    }

    void handleSelectCategory(BuildContext context, Category category) {
        setState(() {
            this._selectCategoryController.text = category.name;
            this._currentInfo.categoryId = category.id;
        });
        Navigator.of(context).pop();
    }

    void handleCreateCategory(BuildContext context) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
                return AddCategoryDialog();
            }
        );

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


    void handleClickSave(BuildContext context) {
        if (this._currentInfo.categoryId.isEmpty) {
            Fluttertoast.showToast(
                msg: this.getI18nValue(context, "category_can_not_empty")
            );
            return;
        }
        if (_formKey.currentState.validate()) {
            _formKey.currentState.save();

            Store<AppState> store = StoreProvider.of<AppState>(context);
            dynamic action;

            if (this.isEdit()) {
                action = new UpdateInfoAction(this._currentInfo);
            } else {
                action = new AddInfoAction(this._currentInfo);
            }
            store.dispatch(action);

            new Future.delayed(new Duration(milliseconds: 1200), () {
                Navigator.pop(context);
            });
        }
    }

    void handleClickDelete(BuildContext context) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
                return new AlertDialog(
                    title: new Text(this.getI18nValue(context, "delete_info")),
                    content: new Text(this.getI18nValue(context, "is_delete_info")),
                    actions: <Widget>[
                        new RaisedButton(
                            child: new Text(this.getI18nValue(context, "cancel")),
                            onPressed: () => Navigator.of(context).pop()
                        ),
                        new RaisedButton(
                            child: new Text(this.getI18nValue(context, "confirm")),
                            onPressed: () {
                                this.executeDeleteInfo(context);
                            }
                        )
                    ],
                );
            }
        );
    }

    void executeDeleteInfo(BuildContext context) {
        Store<AppState> store = this.getStore(context);

        DeleteInfoAction action = new DeleteInfoAction(this._currentInfo);

        store.dispatch(action);

        new Future.delayed(new Duration(milliseconds: 1000), () {
            Navigator.of(context).pushNamedAndRemoveUntil("infoListView", (Route<dynamic> route) => false);
        });
    }

    Info getCurrentInfo(BuildContext context) {
        Store<AppState> store = this.getStore(context);
        List<Info> infos = store.state.infos;

        for (int i = 0, j = infos.length; i < j; ++i) {
            if (infos[i].id == this._editInfoId) {
                return infos[i];
            }
        }
        return null;
    }

    Store<AppState> getStore(BuildContext context) {
        return StoreProvider.of<AppState>(context);
    }


}