class InfoDetail {
    String id;
    String propertyName;
    String propertyValue;
    bool hide;

    InfoDetail(this.id, this.propertyName, this.propertyValue, this.hide);

    InfoDetail.fromJson(Map<String, dynamic> json) {
        id = json["id"];
        propertyName = json["propertyName"];
        propertyValue = json["propertyValue"];
    }

    InfoDetail clone() {
        return new InfoDetail(id, propertyName, propertyValue, hide);
    }

    bool isHide() {
        return this.hide == null ? false : this.hide;
    }

    void setIsHide(bool hide) {
        this.hide = hide;
    }

    Map<String, dynamic> getSaveData() {
        return this.toJson();
    }

    String toString() {
        return '{"id": "$id", "propertyName": "$propertyName", "propertyValue": "$propertyValue", "isHide": $hide}';
    }

    Map<String, dynamic> toJson() {
        return {
            "id": id,
            "propertyName": propertyName,
            "propertyValue": propertyValue,
            "hide": hide
        };
    }

    void setPropertyName(String name) {
        this.propertyName = name;
    }

    void setPropertyValue(String value) {
        this.propertyValue = value;
    }
}