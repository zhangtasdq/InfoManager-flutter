import "package:redux/redux.dart";

import "package:info_manager/store/app_actions.dart";
import "package:info_manager/model/info.dart";

final infosReducer = combineReducers<List<Info>>([
    new TypedReducer<List<Info>, AddInfoAction>(_addInfo),
    new TypedReducer<List<Info>, SetInfosAction>(_setInfos)
]);

List<Info> _addInfo(List<Info> infos, AddInfoAction action) {
    return new List.from(infos)..add(action.info);
}

List<Info> _setInfos(List<Info> infos, SetInfosAction action) {
    return action.infos;
}