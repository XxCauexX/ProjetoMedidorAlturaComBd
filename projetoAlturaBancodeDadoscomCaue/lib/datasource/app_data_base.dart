import 'package:mysql_utils/mysql_utils.dart';

class AppDabase {
  static late MysqlUtils db;

  AppDabase(String dbName) {
    db = MysqlUtils(
        settings: {
          'host': '85.10.205.173',
          'port': 3306,
          'user': 'usercaue_14',
          'password': 'mlkzicka',
          'db': 'db_caue14',
          'maxConnections': 10,
          'secure': false,
          'prefix': 'prefix_',
          'pool': true,
          'collation': 'utf8mb4_general_ci',
          'sqlEscape': true,
        },
        errorLog: (error) {
          print(error);
        },
        sqlLog: (sql) {
          print(sql);
        },
        connectInit: (db1) async {
          print('whenComplete');
        });
  }

  
}
