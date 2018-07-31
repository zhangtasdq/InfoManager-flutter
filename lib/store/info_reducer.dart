import "package:redux/redux.dart";

import "../store/app_actions.dart";
import "../model/info.dart";

final infosReducer = combineReducers<List<Info>>([
    new TypedReducer<List<Info>, AddInfoAction>(_addInfo),
    new TypedReducer<List<Info>, SetInfosAction>(_setInfos),
    new TypedReducer<List<Info>, UpdateInfoAction>(_updateInfo),
    new TypedReducer<List<Info>, DeleteInfoAction>(_deleteInfo)
]);

List<Info> _addInfo(List<Info> infos, AddInfoAction action) {
    return new List.from(infos)..add(action.info);
}

List<Info> _setInfos(List<Info> infos, SetInfosAction action) {
    return action.infos;
}

List<Info> _updateInfo(List<Info> infos, UpdateInfoAction action) {
    List<Info> copy = List.from(infos);

    return copy.map((Info item) {
        if (item.id == action.info.id) {
            return action.info;
        }
        return item;
    }).toList();

}

List<Info> _deleteInfo(List<Info> infos, DeleteInfoAction action) {
    List<Info> copy = List.from(infos);
    Info removeInfo = copy.firstWhere((item) => item.id == action.info.id, orElse: () => null);

    if (removeInfo != null) {
        copy.remove(removeInfo);
    }

    return copy;
}
