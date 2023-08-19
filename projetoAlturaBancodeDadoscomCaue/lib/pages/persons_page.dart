import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import '/classes/pessoa.dart';
import '/pages/alter_page.dart';

class PersonsP extends StatefulWidget {
  const PersonsP({super.key});

  @override
  State<PersonsP> createState() => _PersonsPState();
}

class _PersonsPState extends State<PersonsP> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cadastrados:'),
      ),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  top: 30,
                  left: 10,
                  right: 10,
                ),
                child: FutureBuilder(
                  future: selectFrom(),
                  builder: ((context, snapshot) {
                    List<Widget> children = [];

                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        children = <Widget>[
                          SingleChildScrollView(
                            child: Table(
                              border: TableBorder.all(
                                color: Colors.white,
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(5),
                                ),
                              ),
                              children: tableRowR(
                                snapshot.data!,
                                ctx: context,
                              ),
                              columnWidths: const {
                                0: FlexColumnWidth(2.2),
                                1: FlexColumnWidth(3),
                                2: FlexColumnWidth(1.2),
                                3: FlexColumnWidth(1),
                              },
                            ),
                          )
                        ];
                      }
                    }
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: children,
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<List<Pessoa>> selectFrom() async {
  // Configurando para conexão
  var settings = ConnectionSettings(
      host: '85.10.205.173',
      port: 3306,
      user: 'usercaue_14',
      password: 'mlkzicka',
      db: 'db_caue14');

  // Realizando a conexão
  var conn = await MySqlConnection.connect(settings);

  String sql = "SELECT * FROM pessoa;";
  var results = await conn.query(sql);
  List<Pessoa> list = [];
  for (var row in results) {
    // print('Name: ${row[1]}, curso: ${row[2]}, idade: ${row[3]}, peso: ${row[4]}, altura: ${row[5]}');
    final p = Pessoa(
        id: row[0],
        nome: row[1],
        curso: row[2],
        modulo: row[3],
        idade: row[4],
        peso: row[5],
        altura: row[6]);

    list.add(p);
    // print(p.toString());
  }
  conn.close();
  return list;
}

// Função para criar uma Lista de Widgets <TableRow>, que será usada como parâmetro na
// construção da tabela que será vizualizada pelo usuário.
List<TableRow> tableRowR(List<Pessoa> list, {required BuildContext ctx}) {
  // print("MEY DEUS  ${list.length}");

  const TextStyle ts = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  const TextStyle tsRows = TextStyle(fontSize: 18);

  // Declaração das células da TableRow (linha de tabela ou <tr> no html)
  // Declarei-as no início da função pois na primeira vez que o código for executado
  // será criado o cabeçalho da tabela com o nome das colunas.

  TableCell tcNome;
  TableCell tcCurso;
  TableCell tcIdade;
  TableCell tcModulo;

  //declaração da <tr>
  TableRow tr;

  // Declaração da lista que conterá todas as TableRow de acordo com o tanto de linhas
  // que forem recebidas do banco de dados.
  List<TableRow> l = [];

  // Este laço de repetição criará as TableRow de acordo com a quantidade de linhas na tabela.
  for (int i = 0; i < list.length; i++) {
    // Essa é a condicional que servirá para criar a TableRow que será utilizada como cabeçalho.
    if (i == 0) {
      tcNome = tableCellPaddind('Nome', ts);
      tcCurso = tableCellPaddind('Curso', ts);
      tcIdade = tableCellPaddind('Idade', ts);
      tcModulo = tableCellPaddind('Mód', ts);

      tr = TableRow(
        children: [
          tcNome,
          tcCurso,
          tcIdade,
          tcModulo,
        ],
      );
      // Adicionando a TableRow criada a lista de TableRows declarada no inicio da função
      l.add(tr);
    }

    // essa é a condicional que adiciona realmente os dados provenientes das linhas das tabelas
    // na TableRow, e isso será realizado conforme a quantidade de linhas.
    if (i >= 0 && i <= list.length) {
      tcNome =
          tableCellPaddindButton(list[i].nome, tsRows, ctx: ctx, p: list[i]);
      tcCurso = tableCellPaddind(list[i].curso, tsRows);
      tcIdade = tableCellPaddind('${list[i].idade}', tsRows);
      tcModulo = tableCellPaddind('${list[i].modulo}', tsRows);

      tr = TableRow(
        children: [
          tcNome,
          tcCurso,
          tcIdade,
          tcModulo,
        ],
      );

      // Adicionando a TableRow criada a lista de TableRows declarada no inicio da função
      l.add(tr);
    } else {}
  }
  return l;
}

// Essa função retorna uma TableCell , contendo o texto infomado e o estilo de texto infomado
// Utilizei-a pois já passei um padding para o texto que estará dentro da célula
TableCell tableCellPaddind(var tcContent, TextStyle ts) => TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Padding(
        padding: const EdgeInsets.all(2.0),
        child: Text(
          tcContent.toString(),
          style: ts,
          textAlign: TextAlign.center,
        ),
      ),
    );

TableCell tableCellPaddindButton(var tcContent, TextStyle ts,
        {required BuildContext ctx, required Pessoa p}) =>
    TableCell(
      child: Padding(
          padding: const EdgeInsets.only(left: 2, right: 1, top: 2, bottom: 2),
          child: TextButton(
            onPressed: () => goToAlterPage(ctx, p),
            child: Text(
              tcContent.toString(),
              style: ts,
              textAlign: TextAlign.center,
            ),
          )),
    );

void goToAlterPage(BuildContext ctx, Pessoa p) {
  Navigator.of(ctx).push(
    MaterialPageRoute(
      builder: ((context) => AlterPage(
            p: p,
          )),
    ),
  );
}
