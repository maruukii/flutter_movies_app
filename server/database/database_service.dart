import 'package:mongo_dart/mongo_dart.dart';

class DatabaseService {
  late Db _db;

  Future<void> connect() async {
    const mongoUri =
        'mongodb://localhost:27017/flutter_movie_reviews'; // Replace with your MongoDB URI
    _db = await Db.create(mongoUri);
    await _db.open();
    print('Connected to MongoDB');
  }

  DbCollection getCollection(String collectionName) {
    return _db.collection(collectionName);
  }

  Future<void> close() async {
    await _db.close();
    print('Disconnected from MongoDB');
  }
}
