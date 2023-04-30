

import 'package:sqflite/sqflite.dart';

class DbHelper{
  static final DbHelper _instance = new DbHelper.internal();
  factory DbHelper() => _instance;
  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await initDb();
    return _db!;
  }

  DbHelper.internal();
  /// Incrementar o nome e a versão da base de dados quando se manda uma nova versão para a store.
  initDb() async {
    var theDb = await openDatabase("appointments15.db", version: 15, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    //await db.execute(PlaceModel.create);
    //await db.execute(UserModel.create);
    //await db.execute(UserPlaceModel.create);
    //await db.execute(ServiceModel.create);
  }

}