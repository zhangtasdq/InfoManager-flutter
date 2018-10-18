import "package:flutter/material.dart";
import "package:redux/redux.dart";
import "package:flutter_redux/flutter_redux.dart";
import "package:flutter/services.dart";
import "package:fluttertoast/fluttertoast.dart";

import "../store/app_state.dart";
import "../mixins/i18n_mixin.dart";
import "../model/info.dart";
import "../model/category.dart";
import "../model/info_detail.dart";
import "../views/info_edit.dart";

class InfoShowView extends StatefulWidget {
    String _infoId;

    InfoShowView(this._infoId);

    _InfoShowViewState createState() => _InfoShowViewState(this._infoId);
}

class _InfoShowViewState extends State<InfoShowView> with I18nMixin {
    List<String> _showDetailHideValue = [];
    String _infoId;

    _InfoShowViewState(this._infoId);

    @override
    Widget build(BuildContext context) {
        double appBarHeight = 100.0;

        Info info = getCurrentInfo(context);
        Category category = getCurrentCategory(context);
        String titleName = "${info.title} (${category.name})";

        return Stack(
            children: <Widget>[
                Scaffold(
                    appBar: PreferredSize(
                        preferredSize: Size(MediaQuery.of(context).size.width, appBarHeight),
                        child: Container(
                            color: Colors.blue,
                            child: Container(
                                margin:const EdgeInsets.only(top: 30.0),
                                child: Column(children: <Widget>[
                                    Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                            Row(
                                                children: <Widget>[
                                                    IconButton(
                                                        icon: new Icon(
                                                            Icons.arrow_back,
                                                            color: Colors.white,
                                                        ),
                                                        onPressed: () {
                                                            Navigator.pop(context, false);
                                                        }
                                                    ),
                                                    Text(
                                                        titleName,
                                                        style: new TextStyle(
                                                            fontSize: 20.0,
                                                            fontWeight: FontWeight.bold,
                                                            color: Colors.white
                                                        ),
                                                    ),
                                                ],
                                            ),
                                        ],
                                    ),
                                ]
                                )
                            )
                        )
                    ),
                    body: Center(
                        child: buildInfoDetail(context, info),
                    ),
                ),
                Positioned(
                    child: FloatingActionButton(
                        child: Icon(Icons.edit),
                        onPressed: () {
                            handleTabEditInfo(context, info);
                        },
                        backgroundColor: Colors.lightBlue,
                    ),
                    right: 10.0,
                    top: appBarHeight - 5.0,
                )
            ],
        );
    }

    Widget buildInfoDetail(BuildContext context, Info info) {
        if (info.detailCount == 0) {
            return Center(
                child: Text(getI18nValue(context, "detail_is_empty")),
            );
        }
        return Container(
            child: ListView.builder(
                itemCount: info.detailCount,
                itemBuilder: (BuildContext context, index) {
                    InfoDetail item = info.details[index];

                    return buildInfoDetailItem(context, item);
                }
            ),
        );
    }

    Widget buildInfoDetailItem(BuildContext context, InfoDetail item) {
        return Card(
            child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                    handleTabHideDetailItem(item);
                },
                onLongPress: () => handleLongPressOnDetailItem(item),
                child: Container(
                    padding: EdgeInsets.only(top: 12.0, left: 12.0, bottom: 12.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(bottom: 12.0),
                                child: Text(
                                    item.propertyName,
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold
                                    ),
                                ),
                            ),
                            Text(getDetailItemValue(item))
                        ],
                    ),
                ),
            ),
        );
    }

    String getDetailItemValue(InfoDetail item) {
        if (item.hide != true) {
            return item.propertyValue;
        }

        if (_showDetailHideValue.contains(item.id)) {
            return item.propertyValue;
        }

        return "*********";
    }

    Category getCurrentCategory(BuildContext context) {
        Store<AppState> store = getStore(context);
        List<Category> categories = store.state.categories;
        Info info = getCurrentInfo(context);
        
        return categories.firstWhere((item) => item.id == info.categoryId, orElse: () => null);
    }

    Info getCurrentInfo(BuildContext context) {
        Store<AppState> store = this.getStore(context);
        List<Info> infos = store.state.infos;

        return infos.firstWhere((item) => item.id == _infoId, orElse: () => null);
    }

    Store<AppState> getStore(BuildContext context) {
        return StoreProvider.of<AppState>(context);
    }

    void handleTabHideDetailItem(InfoDetail detail) {
        if (_showDetailHideValue.contains(detail.id)) {
            setState(() {
                _showDetailHideValue.remove(detail.id);
            });
        } else {
            setState(() {
                _showDetailHideValue.add(detail.id);
            });
        }
    }

    void handleLongPressOnDetailItem(InfoDetail detail) {
        Clipboard.setData(ClipboardData(text: detail.propertyValue));
        Fluttertoast.showToast(
            msg: getI18nValue(context, "already_copied_to_clipboard")
        );
    }

    void handleTabEditInfo(BuildContext context, Info info) {
        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (BuildContext context) {
                    return InfoEditView("edit", info.id);
                }
            )
        );
    }
}