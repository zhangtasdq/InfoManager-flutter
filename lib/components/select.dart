import "package:flutter/material.dart";
import "package:flutter_redux/flutter_redux.dart";

import "package:info_manager/store/app_state.dart";
import "package:info_manager/model/category.dart";
import "package:info_manager/mixins/i18n_mixin.dart";

typedef void OnPressSelectSurface(String action, dynamic data);


class Select extends StatelessWidget {
    OnPressSelectSurface onPress;
    List<dynamic> datas;
    String checkedItem;
    String label;

    Select({ this.label, this.datas, this.onPress, this.checkedItem });

    @override
    Widget build(BuildContext context) {
        return new Container(
            padding: new EdgeInsets.only(
                top: 18.0
            ),
            child: new GestureDetector(
                onTap: () {
                    this.handleTabSelect(context);
                },
                child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                        new Container(
                            margin: new EdgeInsets.only(
                            ),
                            child: new Text(
                                this.label,
                                style: new TextStyle(
                                    fontSize: 16.0,
                                    color: Color.fromRGBO(99, 99, 99, 1.0)
                                ),
                            ),
                        ),
                        new Container(
                            padding: EdgeInsets.only(top: 15.0),
                            child: new Row(
                                children: <Widget>[
                                    new Expanded(
                                        child: new Container(
                                            padding: EdgeInsets.only(
                                                bottom: 4.0
                                            ),
                                            decoration: new BoxDecoration(
                                                border: new Border(
                                                    bottom: new BorderSide(
                                                        width: 0.4,
                                                        color: Colors.black
                                                    )
                                                )
                                            ),
                                            child: new Text(
                                                this.getCurrentSelectedLabel(),
                                                style: new TextStyle(
                                                    fontSize: 18.0
                                                ),

                                            ),
                                        ),
                                    ),
                                    new Icon(
                                        Icons.keyboard_arrow_down
                                    )

                                ]
                            )
                        ),
                    ],
                )
            ),
        );
    }

    void handleTabSelect(BuildContext context) {
        this.showSelectDialog(context);
    }

    void showSelectDialog(BuildContext context) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
                return new _SelectDialogContent( this.datas, this.onPress, this.checkedItem);
            }
        );
    }

    String getCurrentSelectedLabel() {
        if (this.checkedItem != null && this.checkedItem.isNotEmpty) {
            dynamic item = this.findSelectDataById(this.checkedItem);

            return item.name;
        }
        return "";
    }

    dynamic findSelectDataById(String id) {
        for (int i = 0, j = this.datas.length; i < j; ++i) {
            if (this.datas[i].id == id) {
                return this.datas[i];
            }
        }
        return null;
    }
}

class _SelectDialogContent extends StatefulWidget {
    OnPressSelectSurface onPress;
    List<dynamic> datas;
    String checkedItem;

    _SelectDialogContent(this.datas, this.onPress, this.checkedItem);

    _SelectDialogContentState createState() => new _SelectDialogContentState(datas: datas, checkedItem: checkedItem, onPress: onPress);
}

class _SelectDialogContentState extends State<_SelectDialogContent> with I18nMixin {
    OnPressSelectSurface onPress;
    List<dynamic> datas;
    String checkedItem;

    _SelectDialogContentState({ this.datas, this.onPress, this.checkedItem });

    @override
    Widget build(BuildContext context) {
        return new AlertDialog(
            title: new Container(
                child: new Row(
                    children: <Widget>[
                        new Expanded(
                            child: new Text(this.getI18nValue(context, "select_category")),
                        ),
                        new IconButton(
                            icon: new Icon(Icons.add, size: 32.0,),
                            onPressed: () => this.onPress("add", null)
                        )
                    ],
                ),
            ),

            content: new Container(
                height: 300.0,
                child: new StoreConnector<AppState, List<Category>>(
                    converter: (store) => store.state.categories,
                    builder: (context, categories) {
                        return new SingleChildScrollView(
                            child: new ListBody(
                                children: this.buildSelectItems(context, categories),
                            ),
                        );
                    },
                ),
            ),
        );
    }

    List<Widget> buildSelectItems(BuildContext context, List<Category> categories) {
        List<Widget> items = [];

        for (int i = 0, j = categories.length; i < j; ++i) {
            items.add(this.buildSelectIem(context, categories[i]));
        }

        return items;
    }

    Widget buildSelectIem(BuildContext context, dynamic item) {
        Icon icon = item.id == checkedItem ? new Icon(Icons.radio_button_checked, color: Colors.blue,) :
        new Icon(Icons.radio_button_unchecked);
        return ListTile(
            key: new Key(item.id),
            title: new Text(item.name),
            trailing: icon,
            onTap: () => this.handleClickItem(item)
        );
    }

    void handleClickItem(dynamic item) {
        setState(() {
            this.checkedItem = item.id;
        });
        this.onPress("checked", item);
    }
}