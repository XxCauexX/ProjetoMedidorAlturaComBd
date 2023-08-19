import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import '/classes/pessoa.dart';

import '../pages/alter_page.dart';

class SqlInteractor {
  static var settings = ConnectionSettings(
        host: '85.10.205.173',
        port: 3306,
        user: 'usercaue_14',
        password: 'mlkzicka',
        db: 'db_caue14');
  static Future<String> updateData(Pessoa p, BuildContext context) async {
    
    // print(p.toString());

    var conn = await MySqlConnection.connect(settings);
    String sql =
        'UPDATE pessoa SET imc = "${p.imc}" WHERE cod_pessoa = ${p.id};';
    print(sql);
    var res = await conn.query(sql);

    String con =
        'SELECT * FROM pessoa WHERE cod_pessoa = ${p.id} AND imc = ${p.imc};';
    var resul = await conn.query(con);
    print(resul.toString());
    conn.close();
    if (resul.isNotEmpty) {
      showSnack(context, 'Atualizado com sucesso!!!');
    } else {
      print(con);
      showSnack(context, 'Não atualizado, algum erro');
    }

    conn.close();
    return '';
  }

  static Future<void> updateImc(Pessoa p) async {
    var conn = await MySqlConnection.connect(settings);

    String sql = 'UPDATE pessoa SET imc = "${p.imc}" WHERE cod_pessoa = ${p.id}';
    print(sql);
    await conn.query(sql);
  }
}
