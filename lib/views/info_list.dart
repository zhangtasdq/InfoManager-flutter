import "package:flutter/material.dart";
import "package:redux/redux.dart";
import "package:flutter_redux/flutter_redux.dart";

import "../model/info.dart";
import "../model/category.dart";
import "../store/app_state.dart";
import "../store/app_actions.dart";
import "../mixins/i18n_mixin.dart";
import "../mixins/msg_mixin.dart";
import "../views/info_edit.dart";
import "../views/info_show.dart";
import "../service/app_service.dart";
import "../configure/status_code.dart";

class InfoListView extends StatefulWidget {
    _InfoListViewState createState() => _InfoListViewState();
}

class _InfoListViewState extends State<InfoListView> with I18nMixin, MsgMixin {
    String _currentCategoryId;
    bool _isShowLoading = false;

    @override
    Widget build(BuildContext context) {
        AppBar appBar = buildAppBar(context);
        double appBarHeight = appBar.preferredSize.height;

        return Scaffold(
            appBar: appBar,
            drawer: buildDrawerLayout(context, appBarHeight),
            body: buildBody(context),
            bottomNavigationBar: buildFooterTab(context),
            floatingActionButton: buildAddBtn(context)
        );
    }

    AppBar buildAppBar(BuildContext context) {
        return AppBar(
            title: Text(getI18nValue(context, "info_list")),
        );
    }

    Widget buildBody(BuildContext context) {
        return StoreConnector<AppState, List<Info>>(
            converter: (store) {
                return store.state.infos;
            },

            builder: (context, stateInfos) {
                List<Info> infos = [];
                List<Widget> children = <Widget>[];

                if (!isContainCategoryById(context, _currentCategoryId)) {
                    List<Category> categories = getAllCategories(context);
                    if (categories.length > 0) {
                        _currentCategoryId = categories[0].id;
                    }
                }

                if (_currentCategoryId != null && stateInfos.length > 0) {
                    stateInfos.forEach((item) {
                        if (item.categoryId == _currentCategoryId) {
                            infos.add(item);
                        }
                    });
                }

                if (infos.length == 0) {
                    children.add(Center(
                        child: Text(getI18nValue(context, "info_is_empty")),
                    ));
                } else {
                    children.add(
                        ListView.builder(
                            itemCount: infos.length,
                            itemBuilder: (context, i) {
                                Info item = infos[i];

                                return Container(
                                    key: Key(item.id),
                                    child: Column(
                                        children: <Widget>[
                                            ListTile(
                                                title: Text(item.title),
                                                onTap: () => handleClickInfoItem(context, item),
                                            ),
                                            Divider(height: 1.0,)
                                        ],
                                    ),
                                );
                            }
                        )
                    );
                }

                if (_isShowLoading) {
                    children.add(buildLoading(context));
                }

                return Stack(children: children);

            },
        );
    }

    Widget buildLoading(BuildContext context) {
        return Center(
            child: CircularProgressIndicator(),
        );
    }

    Widget buildDrawerLayout(BuildContext context, double appBarHeight) {
        BuildContext topContext = context;

        return StoreConnector<AppState, List<Category>>(
            converter: (store) {
                return store.state.categories;
            },
            builder: (context, categories) {
                List<Widget> contents = [];
                double statusBarHeight = MediaQuery.of(context).padding.top;
                
                for (int i = 0, j = categories.length; i < j; ++i) {
                    contents.add(buildCategoryDrawerLayoutItem(context, categories[i], i));
                }

                return Drawer(
                    child: Column(
                        children: <Widget>[
                            Container(
                                margin: EdgeInsets.only(top: statusBarHeight),
                                height: appBarHeight,
                                color: Colors.blue,
                                child: Center(
                                    child: Text(
                                        getI18nValue(context, "category"),
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20.0
                                        ),
                                    ),
                                ),
                            ),
                            Expanded(
                                child: ListView(
                                    padding: EdgeInsets.only(top: 0.0),
                                    children: contents,
                                )
                            ),
                            Container(
                                height: appBarHeight,
                                color: Colors.blue,
                                child: Row(
                                    children: <Widget>[
                                        IconButton(
                                            icon: Icon(Icons.settings, color: Colors.white,),
                                            onPressed: () {
                                                Navigator.of(context).pop();
                                                handleClickSetting(topContext);
                                            }
                                        ),
                                    ],
                                )
                            ),
                        ],
                    ),
                );
            },
        );
    }

    Widget buildCategoryDrawerLayoutItem(BuildContext context, Category category, int index) {
        bool isChecked = category.id == _currentCategoryId;
        List<Widget> children = [];

        if (index != 0) {
            children.add(Divider(height: 1.0,));
        }

        children.add(Container(
            key: Key(category.id),
            color: isChecked ? Colors.lightBlue : Colors.white,
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            child: Text(
                category.name,
                style: TextStyle(
                    color: isChecked ? Colors.white : Colors.black54
                ),
            ),
        ));

        return GestureDetector(
            onTap: () => handleChangeShowCategory(context, category),
            child: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: children,
                ),
            )
        );
    }

    void handleChangeShowCategory(BuildContext context, Category category) {
        if (_currentCategoryId != category.id) {
            setState(() {
                _currentCategoryId = category.id;
            });
        }
        Navigator.of(context).pop();
    }

    Widget buildFooterTab(BuildContext context) {
        return Container(
            color: Colors.blue,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                    IconButton(
                        color: Colors.white,
                        icon: Icon(
                            Icons.cloud_upload,
                            size: 36.0,
                            color: Colors.white
                        ),
                        onPressed: () => handleBackupInfo(context)
                    ),
                    IconButton(
                        icon: Icon(
                            Icons.cloud_download,
                            size: 36.0,
                            color: Colors.white
                        ),
                        onPressed: () => handleRestoreInfo(context)
                    ),
                    IconButton(
                        icon: Icon(
                            Icons.category,
                            size: 36.0,
                            color: Colors.white,
                        ),
                        onPressed: () => handleClickCategory(context)
                    )
                ],
            ),
        );
    }

    Widget buildAddBtn(BuildContext context) {
        return FloatingActionButton(
            onPressed: () => showEditPage(context),
            child: Icon(Icons.add),
        );
    }

    void showEditPage(context) {
        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (BuildContext context) {
                    return InfoEditView("create");
                }
            )
        );
    }

    void handleBackupInfo(BuildContext context) {
        BuildContext topContext = context;

        showDialog(
            context: context,
            builder: (BuildContext context) {
                return AlertDialog(
                    title: Text(getI18nValue(context, "backup_info")),
                    content: Text(getI18nValue(context, "confirm_backup_info")),
                    actions: <Widget>[
                        RaisedButton(
                            child: Text(getI18nValue(context, "cancel")),
                            onPressed: () => Navigator.of(context).pop()
                        ),
                        RaisedButton(
                            child: Text(getI18nValue(context, "confirm")),
                            onPressed: () {
                                Navigator.of(context).pop();
                                executeBackupInfo(topContext);
                            }
                        )
                    ],
                );
            }
        );
    }

    void executeBackupInfo(BuildContext context) {
        setState(() {
            _isShowLoading = true;
        });
        AppService.backupInfo((dynamic error, {dynamic data}) {
            if (error != null) {
                showToast(getI18nValue(context, "backup_info_failed"));
            } else if (data != null) {
                showToast(getI18nValue(context, "backup_info_success"));
            }
            setState(() {
                _isShowLoading = false;
            });
        });
    }

    void handleRestoreInfo(BuildContext context) {
        BuildContext topContext = context;
        showDialog(
            context: context,
            builder: (BuildContext context) {
                return AlertDialog(
                    title: Text(getI18nValue(context, "restore_info")),
                    content: Text(getI18nValue(context, "confirm_restore_info")),
                    actions: <Widget>[
                        RaisedButton(
                            child: Text(getI18nValue(context, "cancel")),
                            onPressed: () => Navigator.of(context).pop()
                        ),
                        RaisedButton(
                            child: Text(getI18nValue(context, "confirm")),
                            onPressed: () {
                                Navigator.of(context).pop();
                                executeRestoreInfo(topContext);
                            }
                        )
                    ],
                );
            }
        );
    }

    void executeRestoreInfo(BuildContext context) {
        Store<AppState> store = getStore(context);
        SetListenStoreStatusAction action = SetListenStoreStatusAction(false);
        store.dispatch(action);

        setState(() {
            _isShowLoading = true;
        });

        AppService.restoreInfo(store, (error, {dynamic data}) {
            if (error != null) {
                switch(data) {
                    case StatusCode.DOWNLOAD_FILE_ERROR:
                        showToast(getI18nValue(context, "download_file_failed"));
                        break;
                    case StatusCode.LOAD_FILE_CONTENT_ERROR:
                        showToast(getI18nValue(context, "load_file_content_failed"));
                        break;
                    case StatusCode.DECRYPT_ERROR:
                        showToast(getI18nValue(context, "restore_failed_by_password"));
                        break;
                    default:
                        showToast(getI18nValue(context, "restore_info_failed"));
                }
            } else {
                showToast(getI18nValue(context, "restore_info_success"));
            }
            setState(() {
                _isShowLoading = false;
            });

            SetListenStoreStatusAction action = SetListenStoreStatusAction(true);
            store.dispatch(action);
        });
    }

    void handleClickInfoItem(BuildContext context, Info info) {
        Navigator.of(context).push(
            MaterialPageRoute(
                builder: (BuildContext context) {
                    return InfoShowView(info.id);
                }
            )
        );
    }

    void handleClickSetting(BuildContext context) {
        Navigator.of(context).pushNamed("settingView");
    }

    void handleClickCategory(BuildContext context) {
        Navigator.of(context).pushNamed("categoryListView");
    }

    bool isContainCategoryById(BuildContext context, String id) {
        List<Category> categories = this.getAllCategories(context);

        return categories.any((item) => item.id == id);
    }

    List<Category> getAllCategories(BuildContext context) {
        return getStore(context).state.categories;
    }

    Store<AppState> getStore(BuildContext context) {
        return StoreProvider.of<AppState>(context);
    }
}