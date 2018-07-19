class InfoDetail {
    String id;
    String propertyName;
    String propertyValue;
    bool hide;

    InfoDetail(this.id, this.propertyName, this.propertyValue, this.hide);

    bool isHide() {
        return this.hide == null ? false : this.hide;
    }

    void setIsHide(bool hide) {
        this.hide = hide;
    }

    String toString() {
        return '{"id": $id, "propertyName": $propertyName, "propertyValue": $propertyValue, "isHide": $hide}';
    }

    void setPropertyName(String name) {
        this.propertyName = name;
    }

    void setPropertyValue(String value) {
        this.propertyValue = value;
    }
}