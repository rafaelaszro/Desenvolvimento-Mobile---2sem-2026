
<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <title>Cadastro de Fotos</title>
</head>
<body>

    <h2>Cadastrar Foto</h2>

    <form action="salvar_foto.php"
          method="POST"
          enctype="multipart/form-data">

        <p>Escolha uma foto:</p>
        <input type="file" name="foto"
               accept="image/*" required>

        <p>Descrição:</p>
        <textarea name="descricao"
                  rows="4" cols="40"
                  required></textarea>

        <br><br>

        <button type="submit">Salvar Foto</button>

    </form>

</body>
</html>
