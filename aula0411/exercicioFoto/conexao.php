<?php

$servidor = "localhost";
$banco = "aula13";
$usuario = "root";
$senha = "";

try {
    $conexao = new PDO("mysql:host=$servidor;dbname=$banco;charset=utf8mb4",$usuario,$senha);

    $conexao->setAttribute(
        PDO::ATTR_ERRMODE,
        PDO::ERRMODE_EXCEPTION
    );

} catch (PDOException $e) {
    http_response_code(500);
    exit("Erro ao conectar ao banco de dados.");
}
?>
