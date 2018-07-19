class Uid {
    static String generateUid() {
        return new DateTime.now().millisecondsSinceEpoch.toString();
    }
}