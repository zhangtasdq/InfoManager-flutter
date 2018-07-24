import "package:info_manager/util/uid.dart";
import "package:info_manager/model/info_detail.dart";

class Info {
    String id;
    String title;
    String categoryId;
    List<InfoDetail> details;

    Info(this.id, this.title, this.categoryId, this.details);

    Info.fromJson(Map<String, dynamic> json) {
        List<InfoDetail> infoDetails = [];
        id = json["id"];
        title = json["title"];
        categoryId = json["categoryId"];

        if (json.containsKey("details")) {
            for (int i = 0, j = json["details"].length; i < j; ++i) {
                infoDetails.add(new InfoDetail.fromJson(json["details"][i]));
            }
        }
        details = infoDetails;
    }

    Info clone() {
        List<InfoDetail> cloneDetails = this.details.map((InfoDetail item) => item.clone()).toList();

        return new Info(id, title, categoryId, cloneDetails);
    }


    bool isExistDetailItemByIndex(int index) {
        return this.details.length > index;

    }

    void addDetailItem(InfoDetail item) {
        this.details.add(item);
    }

    int getDetailCount() {
        return this.details.length;
    }

    void removeDetailItemByIndex(int index) {
        this.details.removeAt(index);
    }

    void addEmptyDetailItem() {
        var item = new InfoDetail(Uid.generateUid(), "", "", true);

        this.addDetailItem(item);
    }

    InfoDetail findDetailByIndex(int index) {
        return this.details[index];
    }

    void setTitle(String title) {
        this.title = title;
    }

    Map<String, dynamic> getSaveData() {
        return this.toJson();
    }

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