import "package:redux/redux.dart";

import "package:info_manager/store/app_actions.dart";
import "package:info_manager/model/info.dart";

final infosReducer = combineReducers<List<Info>>([
    new TypedReducer<List<Info>, AddInfoAction>(_addInfo)
]);

List<Info> _addInfo(List<Info> infos, AddInfoAction action) {
    return new List.from(infos)..add(action.info);
}