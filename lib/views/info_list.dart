import "package:flutter/material.dart";
import "package:flutter_redux/flutter_redux.dart";

import "package:info_manager/model/info.dart";
import "package:info_manager/store/app_state.dart";
import "package:info_manager/mixins/i18n_mixin.dart";
import "package:info_manager/views/info_edit.dart";

class InfoListPage extends StatefulWidget {
    _InfoListPageState createState() => new _InfoListPageState();
}

class _InfoListPageState extends State<InfoListPage> with I18nMixin {

    @override
    void initState() {
        // TODO: implement initState
        super.initState();
    }


    @override
    Widget build(BuildContext context) {
        return new Scaffold(
            appBar: new AppBar(
                title: new Text(this.getI18nValue(context, "info_list"))
            ),
            drawer: this.buildDrawerLayout(context),
            body: this.buildBody(context),
            bottomNavigationBar: this.buildFooterTab(context),
            floatingActionButton: this.buildAddBtn(context)
        );
    }

    Widget buildBody(BuildContext context) {
        return new StoreConnector<AppState, List<Info>>(
            converter: (store) {
                return store.state.infos;
            },

            builder: (context, infos) {
                if (infos.length == 0) {
                    return new Center(
                        child: new Text(this.getI18nValue(context, "info_is_empty")),
                    );
                }
                return new Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                    ],
                );

            },
        );
    }

    Widget buildDrawerLayout(BuildContext context) {
        return new Drawer(
            child: new ListView(
                children: <Widget>[
                    new DrawerHeader(
                        child: new Center(
                            child: new Text(
                                this.getI18nValue(context, "category"),
                                style: new TextStyle(
                                    color: Colors.white
                                ),
                            ),
                        ),
                        decoration: new BoxDecoration(
                            color: Colors.blue
                        ),
                    )
                ],
            ),
        );
    }

    Widget buildFooterTab(BuildContext context) {
        return new Container(
            color: Colors.blue,
            child: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                    new IconButton(
                        color: Colors.white,
                        icon: new Icon(
                            Icons.cloud_upload,
                            size: 36.0,
                            color: Colors.white
                        ),
                        onPressed: null
                    ),
                    new IconButton(
                        icon: new Icon(
                            Icons.cloud_download,
                            size: 36.0,
                            color: Colors.white
                        ),
                        onPressed: null
                    ),
                    new IconButton(
                        icon: new Icon(
                            Icons.settings,
                            size: 36.0,
                            color: Colors.white,
                        ),
                        onPressed: null
                    )
                ],
            ),
        );
    }

    Widget buildAddBtn(BuildContext context) {
        return new FloatingActionButton(
            onPressed: () => this.showEditPage(context),
            child: new Icon(Icons.add),
        );
    }

    void showEditPage(context) {
        Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (BuildContext context) {
                    return new InfoEditPage("create");
                }
            )
        );
        
    }

    @override
    void dispose() {
        // TODO: implement dispose
        super.dispose();
    }
}