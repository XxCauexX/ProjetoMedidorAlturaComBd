<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CalculoFeito</title>
</head>
<body>
    
    <?php
        include 'conexao.php';

        if (filter_input(INPUT_SERVER,'REQUEST_METHOD') == 'POST') {
            $nome = filter_input(INPUT_POST,'nome');
            $idade = filter_input(INPUT_POST,'idade');
            $peso = filter_input(INPUT_POST,'peso');
            
            print "nome: {$nome}<br>Idade: {$idade}<br>Peso: {$peso}";
        }
        else {
            print "Deu ruim";
        }

        $altura = filter_input(INPUT_GET, 'altura',FILTER_SANITIZE_NUMBER_FLOAT);
        if (is_null($altura)) {
            die("Dados inválidos");
        }
       
        $sql = "INSERT INTO pessoa (nome, idade, peso, altura) VALUES ($nome,$idade,$peso,$altura)";
        if (!$conn->query($sql)) {
            //Gravar log de erros
            die("Erro na gravação dos dados no BD");
        }
       
    ?>
</body>
</html>