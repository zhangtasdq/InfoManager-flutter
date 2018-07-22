import "package:flutter/material.dart";
import "package:redux/redux.dart";
import "package:flutter_redux/flutter_redux.dart";

import "package:info_manager/store/app_state.dart";
import "package:info_manager/mixins/i18n_mixin.dart";
import "package:info_manager/model/info.dart";
import "package:info_manager/model/category.dart";
import "package:info_manager/model/info_detail.dart";
import "package:info_manager/views/info_edit.dart";

class InfoShowPage extends StatefulWidget {
    String infoId;

    InfoShowPage(this.infoId);

    _InfoShowPageState createState() => new _InfoShowPageState(this.infoId);
}

class _InfoShowPageState extends State<InfoShowPage> with I18nMixin {
    List<String> showDetailHideValue = [];
    String infoId;

    _InfoShowPageState(this.infoId);

    @override
    Widget build(BuildContext context) {
        double appBarHeight = 100.0;

        Info info = this.getCurrentInfo(context);
        Category category = this.getCurrentCategory(context);
        String titleName = info.title + " ( " + category.name + " )";

        return new Stack(
            children: <Widget>[
                new Scaffold(
                    appBar: new PreferredSize(
                        preferredSize: new Size(MediaQuery.of(context).size.width, appBarHeight),
                        child: new Container(
                            color: Colors.blue,
                            child: new Container(
                                margin:const EdgeInsets.only(top: 30.0),
                                child: new Column(children: <Widget>[
                                    new Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                            new Row(
                                                children: <Widget>[
                                                    new IconButton(
                                                        icon: new Icon(
                                                            Icons.arrow_back,
                                                            color: Colors.white,
                                                        ),
                                                        onPressed: () {
                                                            Navigator.pop(context, false);
                                                        }
                                                    ),
                                                    new Text(
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
                    body: new Center(
                        child: this.buildInfoDetail(context, info),
                    ),
                ),
                new Positioned(
                    child: new FloatingActionButton(
                        child: new Icon(Icons.edit),
                        onPressed: () {
                            this.handleTabEditInfo(context, info);
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
        if (info.getDetailCount() == 0) {
            return new Center(
                child: new Text(this.getI18nValue(context, "detail_is_empty")),
            );
        }
        return new Container(
            child: new ListView.builder(
                itemCount: info.getDetailCount(),
                itemBuilder: (BuildContext context, index) {
                    InfoDetail item = info.details[index];

                    return this.buildInfoDetailItem(context, item);
                }
            ),
        );
    }

    Widget buildInfoDetailItem(BuildContext context, InfoDetail item) {
        return new Card(
            child: new GestureDetector(
                onTap: () {
                    this.handleTabHideDetailItem(item);
                },
                child: new Container(
                    padding: EdgeInsets.only(top: 12.0, left: 12.0, bottom: 12.0),
                    child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                            new Padding(
                                padding: EdgeInsets.only(bottom: 12.0),
                                child: new Text(
                                    item.propertyName,
                                    style: new TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold
                                    ),
                                ),
                            ),
                            new Text(this.getDetailItemValue(item))
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

        if (this.showDetailHideValue.contains(item.id)) {
            return item.propertyValue;
        }

        return "*********";
    }

    Category getCurrentCategory(BuildContext context) {
        Store<AppState> store = this.getStore(context);
        List<Category> categories = store.state.categories;
        Info info = this.getCurrentInfo(context);

        for (int i = 0, j = categories.length; i < j; ++i) {
            if (categories[i].id == info.categoryId) {
                return categories[i];
            }
        }
        return null;
    }

    Info getCurrentInfo(BuildContext context) {
        Store<AppState> store = this.getStore(context);
        List<Info> infos = store.state.infos;

        for (int i = 0, j = infos.length; i < j; ++i) {
            if (infos[i].id == this.infoId) {
                return infos[i];
            }
        }
        return null;
    }

    Store<AppState> getStore(BuildContext context) {
        return StoreProvider.of<AppState>(context);
    }

    void handleTabHideDetailItem(InfoDetail detail) {
        if (this.showDetailHideValue.contains(detail.id)) {
            setState(() {
                this.showDetailHideValue.remove(detail.id);
            });
        } else {
            setState(() {
                this.showDetailHideValue.add(detail.id);
            });
        }
    }

    void handleTabEditInfo(BuildContext context, Info info) {
        Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (BuildContext context) {
                    return new InfoEditPage("edit", info.id);
                }
            )
        );
    }
}