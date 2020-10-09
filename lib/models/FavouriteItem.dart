import 'package:hive/hive.dart';
part 'FavouriteItem.g.dart';
@HiveType(typeId: 2)
class FavouriteItem extends HiveObject{
  @HiveField(0)
  String title;
  @HiveField(1)
  String address;
  @HiveField(2)
  int id;
  FavouriteItem({this.id, this.title, this.address});
}
