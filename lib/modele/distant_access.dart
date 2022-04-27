import 'package:mysql1/mysql1.dart';

class DistantAccess {
  static final DistantAccess _instance = DistantAccess._privateConstructor();

  /// Private unique instance of the controller.
  DistantAccess._privateConstructor();

  /// Gets the single instance of the controller.
  factory DistantAccess() {
    return _instance;
  }

  late MySqlConnection conn;

  var settings = new ConnectionSettings(
      host: 'sql11.freesqldatabase.com',
      port: 3306,
      user: 'sql11488284',
      password: 'TdfGGWPvlF',
      db: 'sql11488284',
      timeout: Duration(seconds: 30));


  Future<Results?> executeSelectQuery(
    String req,
    List<Object> args,
  ) async {
    try{
      conn = await MySqlConnection.connect(settings);
      var result = await conn.query(req, args);
      await conn.close();
      return result;
    }catch(e){
      print(e);
      try{
        await conn.close();
      }catch(e){}
      return null;
    }

  }

  Future<void> close() async{
    await conn.close();
  }
}
