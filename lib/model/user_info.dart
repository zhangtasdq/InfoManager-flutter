class UserInfo {
    String password;
    int maxErrorCount = 5;
    bool isEnableMaxErrorCount = false;

    UserInfo({this.password = ""});

    UserInfo.fromJson(Map<String, dynamic> json):
        password = json["password"],
        isEnableMaxErrorCount = json["isEnableMaxErrorCount"],
        maxErrorCount = json["maxErrorCount"];


    clone() {
        UserInfo info = new UserInfo(password: this.password);
        info.isEnableMaxErrorCount = this.isEnableMaxErrorCount;

        return info;
    }

    String getPassword() {
        return password;
    }

    Map<String, dynamic> getSaveData() {
        return {
            "maxErrorCount": maxErrorCount,
            "isEnableMaxErrorCount": isEnableMaxErrorCount
        };
    }

    @override
    String toString() {
        return '{"password": "$password"}';
    }
}