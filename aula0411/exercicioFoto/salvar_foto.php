
<?php

header("Content-Type: application/json; charset=UTF-8");

require_once "conexao.php";

$descricao = trim($_POST["descricao"] ?? "");

if (
    !isset($_FILES["foto"]) ||
    $_FILES["foto"]["error"] != UPLOAD_ERR_OK ||
    $descricao == ""
) {
    http_response_code(400);
    echo json_encode(["erro" => "Informe foto e descrição"]);
    exit;
}

$foto = $_FILES["foto"];

if ($foto["size"] > 5 * 1024 * 1024) {
    http_response_code(400);
    echo json_encode(["erro" => "Foto muito grande"]);
    exit;
}

$tipo = mime_content_type($foto["tmp_name"]);

$extensoes = [
    "image/jpeg" => "jpg",
    "image/png" => "png",
    "image/webp" => "webp"
];

if (!isset($extensoes[$tipo]) ||
    getimagesize($foto["tmp_name"]) === false) {
    http_response_code(400);
    echo json_encode(["erro" => "Imagem inválida"]);
    exit;
}

$pasta = __DIR__ . "/uploads";

if (!is_dir($pasta)) {
    mkdir($pasta, 0775, true);
}

$nome = bin2hex(random_bytes(12)) . "." . $extensoes[$tipo];
$caminho = "uploads/" . $nome;

if (!move_uploaded_file(
    $foto["tmp_name"],
    __DIR__ . "/" . $caminho
)) {
    http_response_code(500);
    echo json_encode(["erro" => "Erro ao salvar a foto"]);
    exit;
}

$sql = "INSERT INTO fotos (arquivo, descricao)
        VALUES (:arquivo, :descricao)";

$comando = $conexao->prepare($sql);
$comando->bindValue(":arquivo", $caminho);
$comando->bindValue(":descricao", $descricao);
$comando->execute();

echo json_encode([
    "mensagem" => "Foto salva com sucesso",
    "id" => (int) $conexao->lastInsertId()
]);

?>
