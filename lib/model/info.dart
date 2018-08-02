import "../util/uid.dart";
import "../model/info_detail.dart";

class Info {
    String id;
    String title;
    String categoryId;
    List<InfoDetail> details;

    Info(this.id, this.title, this.categoryId, this.details);

    int get detailCount => details.length;
    Map<String, dynamic> get saveData => toJson();

    Info.fromJson(Map<String, dynamic> json) {
        List<InfoDetail> infoDetails = [];

        if (json.containsKey("details")) {
            for (int i = 0, j = json["details"].length; i < j; ++i) {
                infoDetails.add(InfoDetail.fromJson(json["details"][i]));
            }
        }

        id = json["id"];
        title = json["title"];
        categoryId = json["categoryId"];
        details = infoDetails;
    }

    Info clone() {
        List<InfoDetail> cloneDetails = this.details.map((InfoDetail item) => item.clone()).toList();

        return Info(id, title, categoryId, cloneDetails);
    }

    bool isExistDetailItemByIndex(int index) {
        return details.length > index;

    }

    void addDetailItem(InfoDetail item) {
        details.add(item);
    }

    void removeDetailItemByIndex(int index) {
        details.removeAt(index);
    }

    void addEmptyDetailItem() {
        InfoDetail item = new InfoDetail(Uid.generateUid(), "", "", true);

        addDetailItem(item);
    }

    InfoDetail findDetailByIndex(int index) {
        return details[index];
    }

    void setTitle(String title) {
        this.title = title;
    }

    @override
    String toString() {
        String detailStr = this.details.map((item) => item.toString()).join(",");

        return '{"id": "$id", "title": "$title", "categoryId": "$categoryId", "details": [$detailStr]}';
    }

    Map<String, dynamic> toJson() {
        return {
            "id": id,
            "title": title,
            "categoryId": categoryId,
            "details": details
        };
    }
}