import "dart:async";

import "package:flutter/material.dart";
import "package:redux/redux.dart";
import "package:flutter_redux/flutter_redux.dart";
import "package:fluttertoast/fluttertoast.dart";

import "../store/app_state.dart";
import "../store/app_actions.dart";
import "../util/uid.dart";
import "../mixins/i18n_mixin.dart";
import "../model/info.dart";
import "../model/category.dart";
import "../model/info_detail.dart";
import "../components/category_select_list.dart";
import "../components/add_category_dialog.dart";

class InfoEditView extends StatefulWidget {
    final String _viewAction;
    final String _editInfoId;

    InfoEditView(this._viewAction, [this._editInfoId]);

    @override
    _InfoEditViewState createState() => _InfoEditViewState(this._viewAction, this._editInfoId);
}

class _InfoEditViewState extends State<InfoEditView> with I18nMixin {
    bool _isInit = false;
    String _viewAction;
    String _editInfoId;
    Info _currentInfo;
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    TextEditingController _selectCategoryController;

    _InfoEditViewState(this._viewAction, [this._editInfoId]);

    @override
    void initState() {
        super.initState();
        _selectCategoryController = TextEditingController();
    }

    @override
    void dispose() {
        _selectCategoryController.dispose();
        super.dispose();
    }

    @override
    Widget build(BuildContext context) {
        if (_isInit == false) {
            setInitData(context);
            _isInit = true;
        }
        return Scaffold(
            appBar: buildHeader(context),
            body: buildBody(context)
        );
    }

    Widget buildHeader(BuildContext context) {
        List<Widget> actions = [];

        if (isEdit()) {
            actions.add(
                IconButton(
                    icon: Icon(
                        Icons.delete,
                        color: Colors.white
                    ),
                    onPressed: () => handleClickDelete(context)
                )
            );
        }

        actions.add(
            IconButton(
                icon: Icon(
                    Icons.save,
                    color: Colors.white
                ),
                onPressed: () => handleClickSave(context)
            )
        );

        return AppBar(
            title: Text(getTitleStr(context)),
            actions: actions,
        );
    }

    Widget buildBody(BuildContext context) {
        return Container(
            padding: EdgeInsets.only(bottom: 10.0, top: 10.0, left: 10.0, right: 10.0),
            child: Form(
                key: _formKey,
                child: ListView.builder(
                    itemCount: getListItemCount(),
                    itemBuilder: (context, i) {
                        if (i == 0) {
                            return buildMainInfoItem(context);
                        }

                        if (getListItemCount() - 1 == i ) {
                            return buildAddBtn(context);
                        }

                        return buildInfoDetailItem(context, i);
                    }
                )
            ),
        );
    }

    int getListItemCount() {
        return _currentInfo.detailCount + 2;
    }

    Widget buildMainInfoItem(BuildContext context) {
        return Card(
            child: Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                    children: <Widget>[
                        TextFormField(
                            decoration: InputDecoration(
                                labelText: getI18nValue(context, "title"),
                                hintText: getI18nValue(context, "please_input_title"),
                            ),
                            validator: (value) {
                                if (value.isEmpty) {
                                    return getI18nValue(context, "title_can_not_empty");
                                }
                            },
                            onSaved: (value) {
                                _currentInfo.setTitle(value);
                            },
                            initialValue: _currentInfo.title,
                        ),
                        GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            child: TextFormField(
                                controller: _selectCategoryController,
                                decoration: InputDecoration(
                                    labelText: getI18nValue(context, "category"),
                                    labelStyle: DefaultTextStyle.of(context).style,
                                    enabled: false,
                                    suffixIcon: Icon(
                                        Icons.arrow_drop_down
                                    )
                                ),
                            ),
                            onTap: () => showCategorySelectDialog(context)
                        ),
                    ],
                ),
            ),
        );
    }

    Widget buildInfoDetailItem(BuildContext context, int index) {
        int detailIndex = index - 1;
        InfoDetail item = _currentInfo.findDetailByIndex(detailIndex);

        return Card(
            child: Container(
                padding: EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
                child: Stack(children: <Widget>[
                    Positioned(
                        child: IconButton(
                            icon: Icon(Icons.close, color: Colors.red,),
                            onPressed: () => handleDeleteInfoDetailItem(detailIndex)
                        ),
                        top: 0.0,
                        right: 0.0,
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 25.0),
                        child: Column(
                            children: <Widget>[
                                TextFormField(
                                    decoration: InputDecoration(
                                        labelText: getI18nValue(context, "property"),
                                        hintText: getI18nValue(context, "please_input_property"),
                                    ),
                                    validator: (value) {
                                        if (value.isEmpty) {
                                            return getI18nValue(context, "property_can_not_empty");
                                        }
                                    },
                                    onSaved: (value) {
                                        item.setPropertyName(value);
                                    },
                                    initialValue: item.propertyName,

                                ),

                                Row(
                                    children: <Widget>[
                                        Expanded(
                                            child: TextFormField(
                                                decoration: InputDecoration(
                                                    labelText: getI18nValue(context, "content"),
                                                    hintText: getI18nValue(context, "please_input_content"),
                                                ),
                                                validator: (value) {
                                                    if (value.isEmpty) {
                                                        return getI18nValue(context, "content_can_not_empty");
                                                    }
                                                },
                                                onSaved: (value) {
                                                    item.setPropertyValue(value);
                                                },
                                                initialValue: item.propertyValue,
                                            ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(top: 35.0),
                                            child: Checkbox(
                                                value: item.hide,
                                                onChanged: (bool checked) => handleClickHideCheckbox(item, checked)
                                            ),
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(top: 35.0),
                                            child: Text(getI18nValue(context, "hide"))
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
        return Container(
            margin: EdgeInsets.only(top: 30.0),
            child: RaisedButton(
                onPressed: handleClickAddDetailItem,
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Icon(
                    Icons.add,
                    size: 30.0,
                    color: Colors.blue,
                ),
            )
        );
    }

    String getTitleStr(BuildContext context) {
        if (isEdit()) {
            return getI18nValue(context, "edit_info");
        }
        return getI18nValue(context, "create_info");

    }

    bool isEdit() {
        return _viewAction == "edit";
    }

    void setInitData(BuildContext context) {
        if (isEdit()) {
            Category category = getCurrentCategory(context);

            _currentInfo = getCurrentInfo(context).clone();
            _selectCategoryController.text = category.name;
        } else {
            _currentInfo = Info(Uid.generateUid(), "", "", []);
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
                                    child: Text(getI18nValue(context, "select_category")),
                                ),
                                IconButton(
                                    icon: Icon(Icons.add, size: 32.0),
                                    onPressed: () => handleCreateCategory(context),
                                )
                            ],
                        ),
                    ),
                    content: Container(
                        height: 300.0,
                        child: CategorySelectList(
                            checkedItem: _currentInfo.categoryId,
                            onPress: (dynamic item) {
                                handleSelectCategory(context, item);
                            },
                        ),
                    ),
                );
            }
        );
    }

    void handleDeleteInfoDetailItem(int index) {
        setState(() {
            _currentInfo.removeDetailItemByIndex(index);
        });
    }

    void handleSelectCategory(BuildContext context, Category category) {
        setState(() {
            _selectCategoryController.text = category.name;
            _currentInfo.categoryId = category.id;
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
            _formKey.currentState.save();
            _currentInfo.addEmptyDetailItem();
        });
    }


    void handleClickSave(BuildContext context) {
        if (_currentInfo.categoryId.isEmpty) {
            Fluttertoast.showToast(
                msg: getI18nValue(context, "category_can_not_empty")
            );
            return;
        }
        if (_formKey.currentState.validate()) {
            _formKey.currentState.save();

            Store<AppState> store = StoreProvider.of<AppState>(context);
            dynamic action;

            if (this.isEdit()) {
                action = UpdateInfoAction(_currentInfo);
            } else {
                action = AddInfoAction(_currentInfo);
            }
            store.dispatch(action);

            Future.delayed(Duration(milliseconds: 1200), () {
                Navigator.pop(context);
            });
        }
    }

    void handleClickDelete(BuildContext context) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
                return AlertDialog(
                    title: Text(getI18nValue(context, "delete_info")),
                    content: Text(getI18nValue(context, "is_delete_info")),
                    actions: <Widget>[
                        RaisedButton(
                            child: Text(getI18nValue(context, "cancel")),
                            onPressed: () => Navigator.of(context).pop()
                        ),
                        RaisedButton(
                            child: Text(getI18nValue(context, "confirm")),
                            onPressed: () {
                                executeDeleteInfo(context);
                            }
                        )
                    ],
                );
            }
        );
    }

    void executeDeleteInfo(BuildContext context) {
        Store<AppState> store = getStore(context);

        DeleteInfoAction action = DeleteInfoAction(this._currentInfo);

        store.dispatch(action);

        Future.delayed(Duration(milliseconds: 1000), () {
            Navigator.of(context).pushNamedAndRemoveUntil("infoListView", (Route<dynamic> route) => false);
        });
    }

    Category getCurrentCategory(BuildContext context) {
        Store<AppState> store = this.getStore(context);
        List<Category> categories = store.state.categories;
        Info info = this.getCurrentInfo(context);

        return categories.firstWhere((item) => item.id == info.categoryId, orElse: () => null);
    }

    Info getCurrentInfo(BuildContext context) {
        Store<AppState> store = this.getStore(context);
        List<Info> infos = store.state.infos;

        return infos.firstWhere((item) => item.id == _editInfoId, orElse: () => null);
    }

    Store<AppState> getStore(BuildContext context) {
        return StoreProvider.of<AppState>(context);
    }
}