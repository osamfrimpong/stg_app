import 'package:hive/hive.dart';
part 'HTML_item.g.dart';

@HiveType(typeId: 3)
class HTMLItem extends HiveObject {
  @HiveField(0)
  String address;

  @HiveField(1)
  String content;

  @HiveField(2)
  int id;

  @HiveField(3)
  String title;

  HTMLItem({this.address, this.content, this.id, this.title});
}
