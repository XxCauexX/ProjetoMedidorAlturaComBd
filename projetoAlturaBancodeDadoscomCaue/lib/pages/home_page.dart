import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'persons_page.dart';
import 'sql.dart';
import '../widgets/text_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nome = TextEditingController();
  TextEditingController idade = TextEditingController();
  TextEditingController peso = TextEditingController();
  final dropValue = ValueNotifier('');

  final modulo = ValueNotifier('');

  @override
  Widget build(BuildContext context) {
    List<String> mod = [
      "1",
      "2",
      "3",
    ];

    List<String> cursos = [
      'Enfermagem',
      'Administração',
      'Nutrição',
      'Desenvolvimento',
      'Gastronomia',
      'Segurança do Trabalho'
    ];

    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.settings,
          ),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const SqlPage(),
            ),
          ),
        ),
        title: const Text('Cadastrar'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const PersonsP(),
                ),
              );
            },
            icon: const Icon(Icons.table_bar),
          ),
        ],
      ),
      body: Container(
        width: width,
        height: height,
        color: Colors.transparent,
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.only(top: 50),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  textFormFieldP(context, nome, 'Nome'),
                  // SizedBox(
                  //   width: width,
                  //   height: 150,
                  //   child: Row(
                  //     mainAxisAlignment: MainAxisAlignment.center,
                  //     crossAxisAlignment: CrossAxisAlignment.center,
                  //     children: [
                        ValueListenableBuilder(
                          valueListenable: dropValue,
                          builder: (context, value, child) {
                            return Padding(
                              padding: EdgeInsets.only(left: 30, right: 30),
                              child: DropdownButton(
                                hint: const Text('Curso'),
                                value: value.isEmpty ? null : value,
                                isExpanded: true,
                                items: cursos
                                    .map(
                                      (c) => DropdownMenuItem(
                                        value: c,
                                        child: Text(
                                          c,
                                          style:
                                              const TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (i) {
                                  dropValue.value = i.toString();
                                },
                              ),
                            );
                          },
                        ),
                        ValueListenableBuilder(
                          valueListenable: modulo,
                          builder: (context, value, child) {
                            return Padding(
                              padding: const EdgeInsets.only(left: 30, right: 30),
                              child: DropdownButton(
                                hint: const Text('Módulo'),
                                value: value.isEmpty ? null : value,
                                isExpanded: true,
                                items: mod
                                    .map(
                                      (c) => DropdownMenuItem(
                                        value: c,
                                        child: Text(
                                          c,
                                          style:
                                              const TextStyle(fontSize: 18),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (i) {
                                  modulo.value = i.toString();
                                },
                              ),
                            );
                          },
                        ),
                  //     ],
                  //   ),
                  // ),
                  textFormFieldP(
                    context,
                    idade,
                    'Idade',
                  ),
                  textFormFieldP(
                    context,
                    peso,
                    'Peso',
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: SizedBox(
                      width: width,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 30, right: 30),
                        child: Container(
                          decoration: const ShapeDecoration(
                            shape: StadiumBorder(),
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 150, 59, 255),
                                Color.fromARGB(255, 246, 152, 255),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                'Cadastrar',
                                style: TextStyle(fontSize: 30),
                              ),
                            ),
                            onPressed: () async {
                              bool res = await cadastrar(
                                  nome.text,
                                  dropValue.value,
                                  int.parse(modulo.value),
                                  int.parse(idade.text),
                                  double.parse(peso.text),
                                  context);
                              if (res) {
                                showSnack(context);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool> cadastrar(String nome, String curso, int modulo, int idade,
    double peso, BuildContext context) async {
  print('nome $nome, mod: $modulo, $idade, peso $peso');

  var settings = ConnectionSettings(
      host: '85.10.205.173',
      port: 3306,
      user: 'usercaue_14',
      password: 'mlkzicka',
      db: 'db_caue14');
  var conn = await MySqlConnection.connect(settings);

  String create = "CREATE TABLE IF NOT EXISTS pessoa ("
      "cod_pessoa INT PRIMARY KEY AUTO_INCREMENT,"
      "nome VARCHAR(35) NOT NULL,"
      "curso VARCHAR(35) NOT NULL,"
      "modulo INT NOT NULL,"
      "idade INT NOT NULL,"
      "peso FLOAT NOT NULL,"
      "altura FLOAT DEFAULT 0,"
      "imc VARCHAR(100) NULL);";

  var rel = await conn.query(create);
  var results = await conn.query(
      'INSERT INTO pessoa (nome, curso, modulo, idade, peso) VALUES ("$nome", "$curso", $modulo, $idade, $peso);');

  print(rel.fields.toString());

  var res = await conn.query(
      'SELECT * FROM pessoa WHERE nome = "$nome" AND curso = "$curso" AND modulo = $modulo AND idade = $idade AND peso = $peso;');
  conn.close();
  if (res.isNotEmpty) {
    return true;
  } else {
    return false;
  }
}

showSnack(BuildContext context) {
  final snackBar = SnackBar(
    content: const Text('Cadastrado com sucesso!!'),
    action: SnackBarAction(
      label: 'Fechar',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}
