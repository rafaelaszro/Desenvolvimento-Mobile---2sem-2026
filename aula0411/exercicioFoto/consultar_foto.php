
<?php

header("Content-Type: application/json; charset=UTF-8");

require_once "conexao.php";

$id = filter_input(INPUT_GET, "id", FILTER_VALIDATE_INT);

if ($id === false || $id === null || $id < 0) {
    http_response_code(400);
    echo json_encode(["erro" => "ID inválido"]);
    exit;
}

$sql = "SELECT id, arquivo, descricao
        FROM fotos
        WHERE id > :id
        ORDER BY id ASC
        LIMIT 1";

$comando = $conexao->prepare($sql);
$comando->bindValue(":id", $id, PDO::PARAM_INT);
$comando->execute();

$resultado = $comando->fetch(PDO::FETCH_ASSOC);

if ($resultado) {
    $resultado["id"] = (int) $resultado["id"];
    echo json_encode($resultado);
} else {
    echo json_encode(["mensagem" => "Não há mais fotos"]);
}

?>
