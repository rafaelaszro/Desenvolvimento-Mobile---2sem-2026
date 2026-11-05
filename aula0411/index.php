
<?php
require_once "conexao.php";

$mensagem = "";

if ($_SERVER["REQUEST_METHOD"] == "POST") {

    $texto = trim($_POST["texto"] ?? "");
    if ($texto != "") {
        $sql = "INSERT INTO textos (texto) VALUES (:texto)";
        $comando = $conexao->prepare($sql);
        $comando->bindValue(":texto", $texto);
        $comando->execute();
        $mensagem = "Texto salvo com sucesso!";
    } else {
        $mensagem = "Digite um texto!";
    }
}
?>

<!DOCTYPE html>
<html lang="pt-br">

<head>
    <meta charset="UTF-8">
    <title>Cadastro de Textos</title>
</head>

<body>

    <h2>Cadastro de Textos</h2>
    <form method="POST">
        <textarea name="texto" rows="5" cols="40" placeholder="Digite seu texto"></textarea>
        <br><br>
        <button type="submit">Salvar</button>
    </form>

    <p><?php echo htmlspecialchars($mensagem); ?></p>

</body>
</html>
