import 'package:hive/hive.dart';
import 'package:stg_app/models/SubItem.dart';
part 'Content.g.dart';

@HiveType(typeId:0)
class Content extends HiveObject{
  @HiveField(0)
  String title;
  @HiveField(1)
  int id;
  @HiveField(2)
  List<SubItem> subItems;
  Content({required this.id, required this.title, required this.subItems});
}
