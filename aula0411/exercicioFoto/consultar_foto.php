
<?php

header("Content-Type: application/json; charset=UTF-8");

require_once "conexao.php";

$sql = "SELECT id, arquivo FROM fotos ORDER BY id DESC";

$comando = $conexao->prepare($sql);
$comando->execute();

$resultado = $comando->fetchAll(PDO::FETCH_ASSOC);

echo json_encode($resultado);

?>
