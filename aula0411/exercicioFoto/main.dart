
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ImagePicker picker = ImagePicker();

  String servidor = 'http://10.106.76.11/aula13';

  XFile? foto;
  Uint8List? imagem;

  List fotos = [];
  String mensagem = '';

  @override
  void initState() {
    super.initState();
    buscarFotos();
  }

  // Escolher ou tirar uma foto
  void escolherFoto(ImageSource origem) async {
    final arquivo = await picker.pickImage(source: origem);

    if (arquivo != null) {
      final bytes = await arquivo.readAsBytes();

      if (!mounted) return;

      setState(() {
        foto = arquivo;
        imagem = bytes;
      });
    }
  }

  // Enviar foto para o PHP
  void salvar() async {
    if (foto == null) return;

    try {
      var requisicao = http.MultipartRequest(
        'POST',
        Uri.parse('$servidor/salvar_foto.php'),
      );

      requisicao.files.add(
        http.MultipartFile.fromBytes(
          'foto',
          await foto!.readAsBytes(),
          filename: foto!.name,
        ),
      );

      final resposta = await requisicao.send();

      if (!mounted) return;

      if (resposta.statusCode == 200) {
        setState(() {
          mensagem = 'Foto salva com sucesso!';
          foto = null;
          imagem = null;
        });

        buscarFotos();
      } else {
        setState(() {
          mensagem = 'Erro ao salvar foto!';
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        mensagem = 'Erro de conexão!';
      });
    }
  }

  // Buscar todas as fotos cadastradas
  void buscarFotos() async {
    try {
      final resposta = await http.get(
        Uri.parse('$servidor/consultar_foto.php'),
      );

      final dados = jsonDecode(resposta.body);

      if (!mounted) return;

      setState(() {
        fotos = dados;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        mensagem = 'Erro ao buscar fotos!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Galeria de Fotos'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text(
                'Enviar Foto',
                style: TextStyle(fontSize: 22),
              ),

              const SizedBox(height: 15),

              if (imagem != null)
                Image.memory(
                  imagem!,
                  height: 180,
                ),

              ElevatedButton(
                onPressed: () => escolherFoto(ImageSource.camera),
                child: const Text('Tirar foto'),
              ),

              ElevatedButton(
                onPressed: () => escolherFoto(ImageSource.gallery),
                child: const Text('Escolher da galeria'),
              ),

              ElevatedButton(
                onPressed: salvar,
                child: const Text('Salvar foto'),
              ),

              Text(mensagem),

              const Divider(height: 40),

              const Text(
                'Fotos Salvas',
                style: TextStyle(fontSize: 22),
              ),

              const SizedBox(height: 15),

              ElevatedButton(
                onPressed: buscarFotos,
                child: const Text('Atualizar galeria'),
              ),

              const SizedBox(height: 15),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: fotos.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  final fotoAtual = fotos[index];

                  return Image.network(
                    '$servidor/${fotoAtual['arquivo']}',
                    fit: BoxFit.cover,
                    errorBuilder: (context, erro, stack) {
                      return const Icon(Icons.broken_image);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
