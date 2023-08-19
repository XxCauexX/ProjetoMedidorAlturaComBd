class Pessoa {
  int id;
  String nome;
  String curso;
  int modulo;
  int idade;
  double peso;
  double altura;
  String? imc;

  Pessoa(
      {required this.id,
      required this.nome,
      required this.curso,
      required this.modulo,
      required this.idade,
      required this.peso,
      required this.altura,
      String? imc}) {
    if (imc != null) {
      this.imc = imc;
    }
  }

  void setNome(String nome) {
    this.nome = nome;
  }

  void setCurso(String curso) {
    this.curso = curso;
  }

  void setIdade(var idade) {
    this.idade = int.parse(idade);
  }

  void setPeso(var peso) {
    this.peso = double.parse(peso);
  }

  void setAltura(var altura) {
    this.altura = double.parse(altura);
  }

  @override
  String toString() {
    // TODO: implement toString
    return "nome: $nome, curso: $curso, idade: $idade, peso: $peso, altura: $altura";
  }
}
