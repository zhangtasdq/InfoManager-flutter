import "package:redux/redux.dart";

import "package:info_manager/store/app_actions.dart";
import "package:info_manager/model/info.dart";

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
    Info removeInfo;

    for(int i = 0, j = copy.length; i < j; ++i) {
        if (copy[i].id == action.info.id) {
            removeInfo = copy[i];
            break;
        }
    }

    copy.remove(removeInfo);

    return copy;
}
