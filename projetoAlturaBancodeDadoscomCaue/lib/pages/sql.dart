import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import '/classes/global.dart';

class SqlPage extends StatefulWidget {
  const SqlPage({super.key});

  @override
  State<SqlPage> createState() => _SqlPageState();
}

class _SqlPageState extends State<SqlPage> {
  TextEditingController senha = TextEditingController();
  TextEditingController sql = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SQL DE EMERGÊNCIA'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: TextFormField(
                obscuringCharacter: '*',
                obscureText: true,
                controller: senha,
                decoration: const InputDecoration(
                  label: Text('DIGITE A SENHA'),
                  labelStyle: TextStyle(fontSize: 20),
                ),
              ),
            ),
            SingleChildScrollView(
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 300,
                child: TextFormField(
                  controller: sql,
                  decoration: const InputDecoration(
                  label: Text('SQL aq'),
                  labelStyle: TextStyle(fontSize: 20),
                ),
                ),
                
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 20,
                bottom: 20,
              ),
              child: ElevatedButton(
                child: const Text('Enviar'),
                onPressed: () => performQuery(senha.text, sql.text),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<void >performQuery(String senha, String sql) async {
  var settings = ConnectionSettings(
      host: '85.10.205.173',
      port: 3306,
      user: 'usercaue_14',
      password: 'mlkzicka',
      db: 'db_caue14');
  // print(p.toString());

  var conn = await MySqlConnection.connect(settings);

  if(GlobalConfigs.isEqualPass(senha)) {
    await conn.query(sql);
  }
}




