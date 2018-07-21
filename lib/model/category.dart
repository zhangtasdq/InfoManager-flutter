class Category {
    String name;
    String id;

    Category(this.id, this.name);

    Category.fromJson(Map<String, dynamic> json):
        id = json["id"],
        name = json["name"];

    Map<String, dynamic> getSaveData() {
        return this.toJson();
    }

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
