import "package:flutter/material.dart";
import "package:redux/redux.dart";
import "package:flutter_redux/flutter_redux.dart";

import "../model/category.dart";
import "../store/app_state.dart";
import "../store/app_actions.dart";
import "../mixins/i18n_mixin.dart";
import "../mixins/msg_mixin.dart";
import "../components/add_category_dialog.dart";

class CategoryListView extends StatefulWidget {
    _CategoryListViewState createState() => _CategoryListViewState();
}

class _CategoryListViewState extends State<CategoryListView> with I18nMixin, MsgMixin {
    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text(getI18nValue(context, "category_list")),
                actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.add, color: Colors.white),
                        onPressed: () => handleAddCategory(context)
                    )
                ],
            ),
            body: buildBody(context)
        );
    }

    Widget buildBody(BuildContext context) {
        return StoreConnector<AppState, List<Category>>(
            converter: (store) {
                return store.state.categories;
            },

            builder: (context, categories) {
                if (categories.length == 0) {
                    return Center(
                        child: Text(getI18nValue(context, "category_is_empty")),
                    );
                }

                return ListView.builder(
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
                                            onPressed: () => handleDeleteCategory(context, item)
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
        return Center(
            child: CircularProgressIndicator(),
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
                return AlertDialog(
                    title: Text(getI18nValue(context, "delete_category")),
                    content: Text(getI18nValue(context, "confirm_delete_category")),
                    actions: <Widget>[
                        RaisedButton(
                            child: Text(getI18nValue(context, "cancel")),
                            onPressed: () => Navigator.of(context).pop()
                        ),
                        RaisedButton(
                            child: Text(getI18nValue(context, "confirm")),
                            onPressed: () {
                                Navigator.of(context).pop();
                                executeDeleteCategory(topContext, category);
                            }
                        )
                    ],
                );
            }
        );
    }

    void executeDeleteCategory(BuildContext context, Category category) {
        Store<AppState> store = getStore(context);
        DeleteCategoryAction action = DeleteCategoryAction(category);
        store.dispatch(action);
    }


    Store<AppState> getStore(BuildContext context) {
        return StoreProvider.of<AppState>(context);
    }
}
