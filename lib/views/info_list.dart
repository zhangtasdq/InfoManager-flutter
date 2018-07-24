import "package:flutter/material.dart";
import "package:redux/redux.dart";
import "package:flutter_redux/flutter_redux.dart";

import "package:info_manager/model/info.dart";
import "package:info_manager/model/category.dart";
import "package:info_manager/store/app_state.dart";
import "package:info_manager/store/app_actions.dart";
import "package:info_manager/mixins/i18n_mixin.dart";
import "package:info_manager/views/info_edit.dart";
import "package:info_manager/views/info_show.dart";
import "package:info_manager/service/app_service.dart";
import "package:info_manager/mixins/msg_mixin.dart";
import "package:info_manager/configure/status_code.dart";

class InfoListPage extends StatefulWidget {
    _InfoListPageState createState() => new _InfoListPageState();
}

class _InfoListPageState extends State<InfoListPage> with I18nMixin, MsgMixin {
    String currentCategoryId;
    bool isShowLoading = false;

    @override
    Widget build(BuildContext context) {
        List<Category> categoires = this.getAllCategories(context);

        if (this.currentCategoryId == null && categoires.length > 0) {
            this.currentCategoryId = categoires[0].id;
        }

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

            builder: (context, stateInfos) {
                if (this.isShowLoading) {
                    return this.buildLoading(context);
                }

                List<Info> infos = [];

                if (this.currentCategoryId != null && stateInfos.length > 0) {
                    for (int i = 0, j = stateInfos.length; i < j; ++i) {
                        if (stateInfos[i].categoryId == this.currentCategoryId) {
                            infos.add(stateInfos[i]);
                        }
                    }
                }
                if (infos.length == 0) {
                    return new Center(
                        child: new Text(this.getI18nValue(context, "info_is_empty")),
                    );
                }

                return new ListView.builder(
                    itemCount: infos.length,
                    itemBuilder: (context, i) {
                        Info item = infos[i];

                        return new ListTile(
                            title: new Text(item.title),
                            onTap: () => this.handleClickInfoItem(context, item),
                        );
                    }
                );
            },
        );
    }

    Widget buildLoading(BuildContext context) {
        return new Center(
            child: new CircularProgressIndicator(),
        );
    }

    Widget buildDrawerLayout(BuildContext context) {
        return new StoreConnector<AppState, List<Category>>(
            converter: (store) {
                return store.state.categories;
            },
            builder: (context, categories) {
                List<Widget> contents = new List<Widget>();

                Widget header = new DrawerHeader(
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
                );

                contents.add(header);

                for (int i = 0, j = categories.length; i < j; ++i) {
                    contents.add(this.buildCategoryDrawerLayoutItem(context, categories[i]));
                }

                return new Drawer(
                    child: new ListView(
                        children: contents,
                    ),
                );
            },
        );

    }

    Widget buildCategoryDrawerLayoutItem(BuildContext context, Category category) {
        bool isChecked = category.id == this.currentCategoryId;

        return new GestureDetector(
            onTap: () => this.handleChangeShowCategory(context, category),
            child: new Container(
                color: isChecked ? Colors.blue : Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 10.0),
                child: new Text(
                    category.name,
                    style: new TextStyle(
                        color: isChecked ? Colors.white : Colors.black54
                    ),
                ),
            )
        );
    }
    
    void handleChangeShowCategory(BuildContext context, Category category) {
        if (this.currentCategoryId != category.id) {
            setState(() {
                this.currentCategoryId = category.id;
            });
        }
        Navigator.of(context).pop();
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
                        onPressed: () => this.handleBackupInfo(context)
                    ),
                    new IconButton(
                        icon: new Icon(
                            Icons.cloud_download,
                            size: 36.0,
                            color: Colors.white
                        ),
                        onPressed: () => this.handleRestoreInfo(context)
                    ),
                    new IconButton(
                        icon: new Icon(
                            Icons.settings,
                            size: 36.0,
                            color: Colors.white,
                        ),
                        onPressed: () => this.handleClickSetting(context)
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

    void handleBackupInfo(BuildContext context) {
        BuildContext topContext = context;

        showDialog(
            context: context,
            builder: (BuildContext context) {
                return new AlertDialog(
                    title: new Text(this.getI18nValue(context, "backup_info")),
                    content: new Text(this.getI18nValue(context, "confirm_backup_info")),
                    actions: <Widget>[
                        new RaisedButton(
                            child: new Text(this.getI18nValue(context, "cancel")),
                            onPressed: () => Navigator.of(context).pop()
                        ),
                        new RaisedButton(
                            child: new Text(this.getI18nValue(context, "confirm")),
                            onPressed: () {
                                Navigator.of(context).pop();
                                this.executeBackupInfo(topContext);
                            }
                        )
                    ],
                );
            }
        );
    }

    void executeBackupInfo(BuildContext context) {
        setState(() {
            isShowLoading = true;
        });
        AppService.backupInfo((dynamic error, {dynamic data}) {
            if (error != null) {
                this.showToast(this.getI18nValue(context, "backup_info_failed"));
            } else if (data != null) {
                this.showToast(this.getI18nValue(context, "backup_info_success"));
            }
            setState(() {
                isShowLoading = false;
            });
        });
    }

    void handleRestoreInfo(BuildContext context) {
        BuildContext topContext = context;
        showDialog(
            context: context,
            builder: (BuildContext context) {
                return new AlertDialog(
                    title: new Text(this.getI18nValue(context, "restore_info")),
                    content: new Text(this.getI18nValue(context, "confirm_restore_info")),
                    actions: <Widget>[
                        new RaisedButton(
                            child: new Text(this.getI18nValue(context, "cancel")),
                            onPressed: () => Navigator.of(context).pop()
                        ),
                        new RaisedButton(
                            child: new Text(this.getI18nValue(context, "confirm")),
                            onPressed: () {
                                Navigator.of(context).pop();
                                this.executeRestoreInfo(topContext);
                            }
                        )
                    ],
                );
            }
        );
    }

    void executeRestoreInfo(BuildContext context) {
        Store<AppState> store = this.getStore(context);
        SetListenStoreStatusAction action = new SetListenStoreStatusAction(false);
        store.dispatch(action);


        setState(() {
            isShowLoading = true;
        });

        AppService.restoreInfo(store, (error, [statusCode]) {
            if (error != null) {
                this.showToast(this.getI18nValue(context, "restore_info_failed"));
            } else {
                if (statusCode == StatusCode.FILE_NOT_EXIST) {
                    this.showToast(this.getI18nValue(context, "file_not_exist"));
                } else {
                    this.showToast(this.getI18nValue(context, "restore_info_success"));
                }
            }
            setState(() {
                isShowLoading = false;
            });

            SetListenStoreStatusAction action = new SetListenStoreStatusAction(true);
            store.dispatch(action);
        });
    }

    void handleClickInfoItem(BuildContext context, Info info) {
        Navigator.of(context).push(
            new MaterialPageRoute(
                builder: (BuildContext context) {
                    return new InfoShowPage(info.id);
                }
            )
        );
    }

    void handleClickSetting(BuildContext context) {
        Navigator.of(context).pushNamed("setting");
    }

    List<Category> getAllCategories(BuildContext context) {
        return this.getStore(context).state.categories;
    }

    Store<AppState> getStore(BuildContext context) {
        return StoreProvider.of<AppState>(context);
    }
}