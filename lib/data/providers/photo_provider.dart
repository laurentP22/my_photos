import 'package:my_photos/data/db_helper/db_helper.dart';
import 'package:my_photos/models/photo.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class PhotoProvider {

  Future<String> getPath() async{
    return join((await getTemporaryDirectory()).path, '${DateTime.now()}.png',);
  }

  Future<List<Photo>> loadPhotos() async {
    final results = await DBHelper.getAll("photos");
    return results.map((m) => Photo.fromMap(m)).toList();
  }

  Future<int> addPhoto(Photo photo) async {
   return DBHelper.insert("photos", photo.toMap());
  }

  Future<int> deletePhoto(Photo photo) async {
    return DBHelper.delete("photos", photo.id);
  }
}