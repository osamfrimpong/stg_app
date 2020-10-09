class SubItemPODO {
  int id;
  String title;
  String address;

  SubItemPODO({this.id, this.title, this.address});

  factory SubItemPODO.fromJson(dynamic json) {
    return SubItemPODO(
        id: json['id'] as int,
        title: json['title'] as String,
        address: json['address']);
  }

  @override
  String toString() {
    return '{${this.id}, ${this.title}, ${this.address}}';
  }
}
