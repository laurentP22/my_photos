class Photo {
  final int? id;
  final String name;
  final String path;

  Photo({this.id, required this.name, required this.path});

  Photo.fromMap(Map<String, dynamic> map)
      : id = map["id"],
        name = map["name"],
        path = map["path"];

  Map<String, Object> toMap() => {
        'name': name,
        'path': path,
      };
}
