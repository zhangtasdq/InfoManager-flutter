import "package:redux/redux.dart";

import "package:info_manager/store/app_actions.dart";
import "package:info_manager/model/user_info.dart";

final userInfoReducer = combineReducers<UserInfo>([
    new TypedReducer<UserInfo, SetPasswordAction>(_setPassword),
    new TypedReducer<UserInfo, SetUserInfoAction>(_setUserInfo)
]);

UserInfo _setPassword(UserInfo userInfo, SetPasswordAction action) {
    UserInfo info = userInfo.clone();

    info.password = action.password;

    return info;
}

UserInfo _setUserInfo(UserInfo userInfo, SetUserInfoAction action) {
    return action.userInfo;
}
