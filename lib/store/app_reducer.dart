import "package:info_manager/store/app_state.dart";
import "package:info_manager/store/info_reducer.dart";
import "package:info_manager/store/user_info_reducer.dart";

AppState appReducer(AppState state, action) {
    return new AppState(
        infos: infosReducer(state.infos, action),
        info: userInfoReducer(state.userInfo, action)
    );
}
