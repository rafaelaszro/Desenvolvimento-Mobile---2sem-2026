
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Cadastro de Fotos</title>
</head>
<body>

    <h2>Enviar Foto</h2>

    <form action="salvar_foto.php"
          method="POST"
          enctype="multipart/form-data">

        <input type="file"
               name="foto"
               accept="image/*"
               required>

        <br><br>

        <button type="submit">Salvar Foto</button>

    </form>

    <hr>

    <h2>Consultar Fotos</h2>

    <form action="consultar_foto.php" method="GET">
        <label>ID:</label>
        <input type="number" name="id" value="0" min="0">

        <button type="submit">Consultar</button>
    </form>

</body>
</html>
