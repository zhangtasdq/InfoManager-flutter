import "package:info_manager/util/uid.dart";
import "package:info_manager/model/info_detail.dart";

class Info {
    String id;
    String title;
    String categoryId;
    List<InfoDetail> details;

    Info(this.id, this.title, this.categoryId, this.details);

    bool isExistDetailItemByIndex(int index) {
        return this.details.length > index;

    }

    void addDetailItem(InfoDetail item) {
        this.details.add(item);
    }

    int getDetailCount() {
        return this.details.length;
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

    String toString() {
        String detailStr = this.details.map((item) => item.toString()).join(",");

        return '{"id": $id, "title": $title, "categoryId": $categoryId, "details": [$detailStr]}';
    }
}