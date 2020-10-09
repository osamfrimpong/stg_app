import 'package:stg_app/models/podo/SubItemPODO.dart';

class ContentPODO {
  int chapter;
  String title;
  List<SubItemPODO> subItems;

  ContentPODO({this.chapter, this.title, this.subItems});

  factory ContentPODO.fromJson(dynamic json) {
    var subItemsJSON = json['subitems'] as List;
    List<SubItemPODO> _subItems = subItemsJSON
        .map((subItemJSON) => SubItemPODO.fromJson(subItemJSON))
        .toList();
    return ContentPODO(
        chapter: json['chapter'] as int,
        title: json['title'] as String,
        subItems: _subItems);
  }

  @override
  String toString() {
    return '{${this.chapter}, ${this.title}, ${this.subItems}';
  }
}
