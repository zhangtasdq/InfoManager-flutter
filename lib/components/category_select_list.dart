import "package:flutter/material.dart";
import "package:flutter_redux/flutter_redux.dart";

import "../store/app_state.dart";
import "../model/category.dart";

typedef void OnPressSelectSurface(dynamic data);

class CategorySelectList extends StatefulWidget {
    String checkedItem;
    OnPressSelectSurface onPress;

    CategorySelectList({this.checkedItem, this.onPress});

    _SelectListState createState() => new _SelectListState(
        checkedItem: checkedItem,
        onPress: onPress
    );
}

class _SelectListState extends State<CategorySelectList> {
    String checkedItem;
    OnPressSelectSurface onPress;


    _SelectListState({
        this.checkedItem,
        this.onPress
    });

    @override
    Widget build(BuildContext context) {
        return SingleChildScrollView(
            child: new StoreConnector<AppState, List<Category>>(
                converter: (store) => store.state.categories,
                builder: (context,datas) {
                    return ListBody(
                        children: this.buildSelectItems(context, datas),
                    );
                },
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
        Icon icon = item.id == checkedItem ? Icon(Icons.radio_button_checked, color: Colors.blue,) :
                                              Icon(Icons.radio_button_unchecked);
        return ListTile(
            key: Key(item.id),
            title: Text(item.name),
            trailing: icon,
            onTap: () => this.handleClickItem(item)
        );
    }

    void handleClickItem(dynamic item) {
        setState(() {
            checkedItem = item.id;
        });

        if (onPress != null) {
            onPress(item);
        }
    }
}
