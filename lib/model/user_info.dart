class UserInfo {
    String password;

    UserInfo({this.password = ""});

    clone() {
        return new UserInfo(
            password: this.password
        );
    }
}