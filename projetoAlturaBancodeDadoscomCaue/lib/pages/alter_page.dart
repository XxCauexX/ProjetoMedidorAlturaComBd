import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import '/classes/slq_class.dart';
import '/pages/home_page.dart';
import '../classes/pessoa.dart';

Pessoa? person;

class AlterPage extends StatefulWidget {
  const AlterPage({
    required this.p,
    super.key,
  });
  final Pessoa p;

  @override
  State<AlterPage> createState() => _AlterPageState();
}

class _AlterPageState extends State<AlterPage> {
  TextEditingController nome = TextEditingController();
  TextEditingController idade = TextEditingController();
  TextEditingController peso = TextEditingController();
  TextEditingController altura = TextEditingController();

  List<String> cursos = [
    'Enfermagem',
    'Administração',
    'Nutrição',
    'Desenvolvimento',
    'Gastronomia',
    'Segurança do Trabalho'
  ];

  List<String> mod = [
    '1',
    '2',
    '3',
  ];
  String val = "";
  final dropValue = ValueNotifier<String>('');
  final modulo = ValueNotifier('');
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int inte = 0;
  double? imc;

  @override
  void initState() {
    super.initState();
    double alturaA = widget.p.altura;
    double pesoA = widget.p.peso;

    imc = pesoA / (alturaA * alturaA);
    widget.p.imc = doImc(imc!, imc!.toStringAsFixed(2));
    if (imc != null && imc! > 0 && widget.p.imc != '') {
      setState(() {
        if (widget.p.imc != null) {
          val = widget.p.imc.toString();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (imc! > 0) {
      SqlInteractor.updateImc(widget.p);
    }
    if (inte == 0) {
      nome.text = widget.p.nome;
      idade.text = widget.p.idade.toString();
      peso.text = widget.p.peso.toString();
      altura.text = widget.p.altura.toString();

      dropValue.value = widget.p.curso;
      modulo.value = widget.p.modulo.toString();
      inte++;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.p.nome),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                formFieldPad(context, nome, 'Nome'),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 100,
                        child: Text(
                          'Curso:',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: 250,
                        child: ValueListenableBuilder(
                          valueListenable: dropValue,
                          builder: (context, value, _) {
                            return DropdownButton(
                              value: value.isEmpty ? null : value,
                              isExpanded: true,
                              onChanged: (i) {
                                dropValue.value = i.toString();
                              },
                              items: cursos
                                  .map(
                                    (c) => DropdownMenuItem(
                                      value: c,
                                      child: Text(
                                        c,
                                        style: const TextStyle(
                                          fontSize: 18,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  )
                                  .toList(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 100,
                        child: Text(
                          'Módulo',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                      SizedBox(
                        width: 250,
                        child: ValueListenableBuilder(
                          valueListenable: modulo,
                          builder: (context, value, _) {
                            return DropdownButton(
                              hint: const Text('Módulo'),
                              value: value.isEmpty ? null : value,
                              isExpanded: true,
                              onChanged: (i) {
                                modulo.value = i.toString();
                              },
                              items: mod
                                  .map(
                                    (c) => DropdownMenuItem(
                                      value: c,
                                      child: Text(c,
                                          style: const TextStyle(fontSize: 18)),
                                    ),
                                  )
                                  .toList(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                formFieldPad(context, idade, 'Idade'),
                formFieldPad(context, peso, 'Peso'),
                formFieldPad(context, altura, 'Altura'),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 70,
                    child: Center(
                      child: SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 170,
                              height: 100,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: ElevatedButton(
                                  child: const Text(
                                    'Atualizar',
                                    style: TextStyle(fontSize: 26),
                                  ),
                                  onPressed: () {
                                    updateData(
                                        widget.p,
                                        [
                                          nome.text,
                                          dropValue.value,
                                          modulo.value,
                                          idade.text,
                                          peso.text,
                                          altura.text
                                        ],
                                        context);
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: SizedBox(
                                width: 170,
                                height: 100,
                                child: ElevatedButton(
                                  child: const Text('Excluir',
                                      style: TextStyle(fontSize: 26)),
                                  onPressed: () {
                                    deleteData(widget.p, context);
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.only(top: 20),
                // child: SizedBox(
                //   width: MediaQuery.of(context).size.width,
                //   height: 76,
                //   child: ElevatedButton(
                //     child: Text(
                //       'Calcular IMC',
                //       style: TextStyle(fontSize: 26),
                //     ),
                //     onPressed: () async {
                //       double alturaA = widget.p.altura;
                //       double pesoA = widget.p.peso;

                //       double imc = pesoA / (alturaA * alturaA);

                //       String imcC =
                //           (pesoA / (alturaA * alturaA)).toStringAsFixed(2);
                //     },
                //   ),
                // ),
                // ),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    val,
                    style: const TextStyle(fontSize: 26),
                  ),
                ),
                FutureBuilder(
                  builder: (context, snapshot) => Container(),
                  future: SqlInteractor.updateData(widget.p, context),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget formFieldPad(BuildContext ctx, TextEditingController tx, String label) {
  return Padding(
    padding: const EdgeInsets.only(
      top: 10,
      bottom: 10,
    ),
    child: TextFormField(
        autofocus: true,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          label: Text(label),
          labelStyle: const TextStyle(fontSize: 22),
        ),
        controller: tx,
        onFieldSubmitted: (value) => tx.text = value),
  );
}

Future<void> updateData(
    Pessoa p, List<dynamic> datas, BuildContext context) async {
  var settings = ConnectionSettings(
      host: '85.10.205.173',
      port: 3306,
      user: 'usercaue_14',
      password: 'mlkzicka',
      db: 'db_caue14');
  // print(p.toString());

  var conn = await MySqlConnection.connect(settings);
  String sql =
      "UPDATE pessoa SET nome = '${datas[0]}', curso = '${datas[1]}', modulo = ${int.parse(datas[2])}, idade = ${int.parse(datas[3])},peso = ${double.parse(datas[4])}, altura = ${double.parse(datas[5])} WHERE cod_pessoa = ${p.id};";
  var res = await conn.query(sql);

  String con = 'SELECT * FROM pessoa WHERE cod_pessoa = ${p.id};';
  var resul = await conn.query(con);
  conn.close();
  if (resul.isNotEmpty) {
    showSnack(context, 'Atualizado com sucesso!!!');
  } else {
    print(con);
    showSnack(context, 'Não atualizado, algum erro');
  }

  conn.close();
}

showSnack(BuildContext context, String txt) {
  final snackBar = SnackBar(
    content: Text(txt),
    action: SnackBarAction(
      label: 'Fechar',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Future<void> deleteData(Pessoa p, BuildContext ctx) async {
  var settings = ConnectionSettings(
      host: '85.10.205.173',
      port: 3306,
      user: 'usercaue_14',
      password: 'mlkzicka',
      db: 'db_caue14');
  // print(p.toString());

  var conn = await MySqlConnection.connect(settings);

  String sql = "DELETE FROM pessoa WHERE cod_pessoa = ${p.id}";

  Results res = await conn.query(sql);

  String verify = "SELECT * FROM pessoa WHERE cod_pessoa = ${p.id}";

  Results resul = await conn.query(verify);
  conn.close();

  if (resul.isEmpty) {
    Navigator.of(ctx).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const HomePage(),
      ),
    );
  }
}

String validate(String? text) {
  if (text != null && double.parse(text) == 0) {
    return "NÃO PODE SER 0";
  } else {
    return "";
  }
}

String doImc(double imc, String imcC) {
  String val;
  if (imc < 18.5) {
    val = "Você está muito magro(a)! Seu IMC é de $imcC.";
  } else if (imc >= 18.5 && imc < 25) {
    val = "Você está normal! Seu IMC é de $imcC.";
  } else if (imc >= 25 && imc < 30) {
    val = "Você está com sobrepeso! Seu IMC é de $imcC.";
  } else if (imc >= 30 && imc < 35) {
    val = "Você está com Obesidade grau I. Seu IMC é de $imcC.";
  } else if (imc >= 35 && imc < 40) {
    val = "Você está com Obesidade grau II. Seu IMC é de $imcC.";
  } else {
    val = "Você está com Obesidade Grau II. Seu IMC é de $imcC.";
  }

  return val;
}
