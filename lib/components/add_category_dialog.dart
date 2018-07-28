import "package:flutter/material.dart";
import "package:flutter_redux/flutter_redux.dart";

import "../store/app_state.dart";
import "../store/app_actions.dart";
import "../model/category.dart";
import "../mixins/i18n_mixin.dart";
import "../util/uid.dart";

typedef void AddCategoryActionType(Category category);

class AddCategoryDialog extends StatefulWidget {
    _AddCategoryDialogState createState() => new _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> with I18nMixin {
    GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
    String categoryName = "";

    @override
    Widget build(BuildContext context) {
        return new AlertDialog(
            content: new Form(
                key: _formKey,
                child: new TextFormField(
                    decoration: new InputDecoration(
                        labelText: this.getI18nValue(context, "category_name"),
                        hintText: this.getI18nValue(context, "please_input_category_name")
                    ),
                    validator: (value) {
                        if (value.isEmpty) {
                            return this.getI18nValue(context, "please_input_category_name");
                        }
                    },

                    onSaved: (value) {
                        categoryName = value;
                    },
                )
            ),
            actions: <Widget>[
                new RaisedButton(
                    onPressed: () {
                        Navigator.of(context).pop();
                    },
                    child: new Text(
                        this.getI18nValue(context, "cancel")
                    ),
                ),
                new StoreConnector<AppState, AddCategoryActionType>(
                    converter: (store) {
                        return (Category category) {
                            store.dispatch(new AddCategoryAction(category));
                        };
                    },
                    builder: (context, addCategoryAction) {
                        return new RaisedButton(
                            onPressed: () {
                                if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                    Category item = new Category(Uid.generateUid(), categoryName);

                                    addCategoryAction(item);
                                    Navigator.of(context).pop();
                                }
                            },
                            child: new Text(
                                this.getI18nValue(context, "save")
                            ),
                        );

                    },
                ),
            ],
        );
    }
}