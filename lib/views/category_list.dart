import "package:flutter/material.dart";
import "package:redux/redux.dart";
import "package:flutter_redux/flutter_redux.dart";

import "package:info_manager/model/category.dart";
import "package:info_manager/store/app_state.dart";
import "package:info_manager/store/app_actions.dart";
import "package:info_manager/mixins/i18n_mixin.dart";
import "package:info_manager/mixins/msg_mixin.dart";
import "package:info_manager/util/uid.dart";

import "../components/add_category_dialog.dart";

typedef void AddCategoryActionType(Category category);

class CategoryListView extends StatefulWidget {
    _CategoryListViewState createState() => new _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> with I18nMixin, MsgMixin {
    @override
    Widget build(BuildContext context) {
        return new Scaffold(
            appBar: new AppBar(
                title: new Text(this.getI18nValue(context, "category_list")),
                actions: <Widget>[
                    new IconButton(
                        icon: new Icon(Icons.add, color: Colors.white),
                        onPressed: () => this.handleAddCategory(context)
                    )
                ],
            ),
            body: this.buildBody(context)
        );
    }

    Widget buildBody(BuildContext context) {
        return new StoreConnector<AppState, List<Category>>(
            converter: (store) {
                return store.state.categories;
            },

            builder: (context, categories) {
                if (categories.length == 0) {
                    return Center(
                        child: Text(this.getI18nValue(context, "category_is_empty")),
                    );
                }

                return new ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, i) {
                        Category item = categories[i];

                        return Container(
                            child: Column(
                                children: <Widget>[
                                    ListTile(
                                        title: Text(item.name),
                                        trailing: IconButton(
                                            icon: Icon(Icons.delete, color: Colors.red),
                                            onPressed: () => this.handleDeleteCategory(context, item)
                                        ),
                                    ),
                                    Divider(height: 1.0,)
                                ]
                            )
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
    
    void handleAddCategory(BuildContext context) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
                return AddCategoryDialog();
            }
        );
    }

    void handleDeleteCategory(BuildContext context, Category category) {
        BuildContext topContext = context;

        showDialog(
            context: context,
            builder: (BuildContext context) {
                return new AlertDialog(
                    title: new Text(this.getI18nValue(context, "delete_category")),
                    content: new Text(this.getI18nValue(context, "confirm_delete_category")),
                    actions: <Widget>[
                        new RaisedButton(
                            child: new Text(this.getI18nValue(context, "cancel")),
                            onPressed: () => Navigator.of(context).pop()
                        ),
                        new RaisedButton(
                            child: new Text(this.getI18nValue(context, "confirm")),
                            onPressed: () {
                                Navigator.of(context).pop();
                                this.executeDeleteCategory(topContext, category);
                            }
                        )
                    ],
                );
            }
        );
    }

    void executeDeleteCategory(BuildContext context, Category category) {
        Store<AppState> store = this.getStore(context);
        DeleteCategoryAction action = new DeleteCategoryAction(category);
        store.dispatch(action);
    }


    Store<AppState> getStore(BuildContext context) {
        return StoreProvider.of<AppState>(context);
    }
}
