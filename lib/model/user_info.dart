class UserInfo {
    String password;
    int maxErrorCount = 5;

    UserInfo({this.password = ""});

    UserInfo.fromJson(Map<String, dynamic> json):
        password = json["password"],
        maxErrorCount = json["maxErrorCount"];


    clone() {
        return new UserInfo(
            password: this.password
        );
    }

    String getPassword() {
        return password;
    }

    Map<String, dynamic> getSaveData() {
        return {
            "maxErrorCount": maxErrorCount
        };
    }

    @override
    String toString() {
        return '{"password": "$password"}';
    }
}