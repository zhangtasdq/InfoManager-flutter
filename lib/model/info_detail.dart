class InfoDetail {
    String id;
    String propertyName;
    String propertyValue;
    bool hide;

    InfoDetail(this.id, this.propertyName, this.propertyValue, this.hide);

    bool get isHide => hide ?? false;
    Map<String, dynamic> get saveData => toJson();

    InfoDetail.fromJson(Map<String, dynamic> json):
        id = json["id"],
        propertyName = json["propertyName"],
        propertyValue = json["propertyValue"],
        hide = json["hide"];

    InfoDetail clone() {
        return InfoDetail(id, propertyName, propertyValue, hide);
    }

    void setIsHide(bool hide) {
        this.hide = hide;
    }

    void setPropertyName(String name) {
        this.propertyName = name;
    }

    void setPropertyValue(String value) {
        this.propertyValue = value;
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
}