class Category {
    String name;
    String id;

    Category(this.id, this.name);

    Map<String, dynamic> get saveData => toJson();

    Category.fromJson(Map<String, dynamic> json):
        id = json["id"],
        name = json["name"];

    @override
    String toString() {
        return '{"id": "$id", "name": "$name"}';
    }

    Map<String, dynamic> toJson() {
        return {
            "id": id,
            "name": name
        };
    }
}
