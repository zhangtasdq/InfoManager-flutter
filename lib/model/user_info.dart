class UserInfo {
    String password;
    int maxErrorCount = 5;

    UserInfo({this.password = ""});

    Map<String, dynamic> get saveData {
        return {
            "maxErrorCount": maxErrorCount
        };
    }

    UserInfo.fromJson(Map<String, dynamic> json):
        password = json["password"],
        maxErrorCount = json["maxErrorCount"];


    clone() {
        return UserInfo(password: this.password);
    }

    @override
    String toString() {
        return '{"password": "$password"}';
    }
}