import "package:redux/redux.dart";

import "package:info_manager/store/app_actions.dart";
import "package:info_manager/model/user_info.dart";

final userInfoReducer = combineReducers<UserInfo>([
    new TypedReducer<UserInfo, SetPasswordAction>(_setPassword)
]);

UserInfo _setPassword(UserInfo userInfo, SetPasswordAction action) {
    UserInfo info = userInfo.clone();

    info.password = action.password;

    return info;
}

