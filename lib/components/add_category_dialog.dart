import "package:flutter/material.dart";
import "package:flutter_redux/flutter_redux.dart";

import "../store/app_state.dart";
import "../store/app_actions.dart";
import "../model/category.dart";
import "../mixins/i18n_mixin.dart";
import "../util/uid.dart";
import "../types.dart";


class AddCategoryDialog extends StatefulWidget {
    _AddCategoryDialogState createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> with I18nMixin {
    GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    String _categoryName = "";

    @override
    Widget build(BuildContext context) {
        return AlertDialog(
            content: Form(
                key: _formKey,
                child: TextFormField(
                    autofocus: true,
                    decoration: InputDecoration(
                        labelText: getI18nValue(context, "category_name"),
                        hintText: getI18nValue(context, "please_input_category_name")
                    ),
                    validator: (value) {
                        if (value.isEmpty) {
                            return getI18nValue(context, "please_input_category_name");
                        }
                    },
                    onSaved: (value) {
                        _categoryName = value;
                    },
                )
            ),
            actions: <Widget>[
                RaisedButton(
                    onPressed: () {
                        Navigator.of(context).pop();
                    },
                    child: Text(
                        getI18nValue(context, "cancel")
                    ),
                ),
                StoreConnector<AppState, AddCategoryActionType>(
                    converter: (store) {
                        return (Category category) {
                            store.dispatch(AddCategoryAction(category));
                        };
                    },
                    builder: (context, addCategoryAction) {
                        return RaisedButton(
                            onPressed: () {
                                if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                    Category item = Category(Uid.generateUid(), _categoryName);

                                    addCategoryAction(item);
                                    Navigator.of(context).pop();
                                }
                            },
                            child: Text(
                                getI18nValue(context, "save")
                            ),
                        );

                    },
                ),
            ],
        );
    }
}