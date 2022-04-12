import 'package:mysql1/mysql1.dart';

class DistantAccess {
  static final DistantAccess _instance = DistantAccess._privateConstructor();

  /// Private unique instance of the controller.
  DistantAccess._privateConstructor() {
    _init();
  }

  /// Gets the single instance of the controller.
  factory DistantAccess() {
    return _instance;
  }

  late MySqlConnection conn;
  var settings = new ConnectionSettings(
      host: 'sql11.freesqldatabase.com',
      port: 3306,
      user: 'sql11485073',
      password: 'P2cmeRHHA8',
      db: 'sql11485073');

  Future<void> _init() async {
    conn = await MySqlConnection.connect(settings);
  }

  Future<Results> executeSelectQuery(
    String req,
    List<Object> args,
  ) async {
    return await conn.query(req, args);
  }
}
