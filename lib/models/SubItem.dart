import 'package:hive/hive.dart';
part 'SubItem.g.dart';
@HiveType(typeId: 1)
class SubItem extends HiveObject{
  @HiveField(0)
  String title;
  @HiveField(1)
  String address;
  @HiveField(2)
  int id;
  SubItem({required this.id, required this.title, required this.address});
}
