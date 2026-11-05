
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
  TextEditingController controlador = TextEditingController();

  final ImagePicker picker = ImagePicker();

  // Emulador Android
  String servidor = 'http://10.0.2.2/aula13';

  XFile? foto;
  Uint8List? imagem;

  int id = 0;
  String fotoSalva = '';
  String descricaoSalva = '';
  String mensagem = '';

  // Tirar foto ou escolher da galeria
  void escolherFoto(ImageSource origem) async {
    try {
      final arquivo = await picker.pickImage(
        source: origem,
        imageQuality: 75,
      );

      if (arquivo != null) {
        final bytes = await arquivo.readAsBytes();

        if (!mounted) return;

        setState(() {
          foto = arquivo;
          imagem = bytes;
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        mensagem = 'Erro ao selecionar foto!';
      });
    }
  }

  // Enviar foto e descrição para o PHP
  void salvar() async {
    if (foto == null || controlador.text.trim().isEmpty) {
      setState(() {
        mensagem = 'Selecione uma foto e digite a descrição!';
      });
      return;
    }

    try {
      var requisicao = http.MultipartRequest(
        'POST',
        Uri.parse('$servidor/salvar_foto.php'),
      );

      requisicao.fields['descricao'] = controlador.text;

      requisicao.files.add(
        http.MultipartFile.fromBytes(
          'foto',
          await foto!.readAsBytes(),
          filename: foto!.name,
        ),
      );

      final resposta = await requisicao.send();
      final conteudo = await resposta.stream.bytesToString();
      final dados = jsonDecode(conteudo);

      if (!mounted) return;

      if (resposta.statusCode == 200) {
        setState(() {
          mensagem = 'Foto salva com sucesso!';
          foto = null;
          imagem = null;
          controlador.clear();
        });
      } else {
        setState(() {
          mensagem = dados['erro'] ?? 'Erro ao salvar foto!';
        });
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        mensagem = 'Erro de conexão com o PHP!';
      });
    }
  }

  // Mostrar a próxima foto salva
  void proximo() async {
    try {
      final resposta = await http.get(
        Uri.parse('$servidor/consultar_foto.php?id=$id'),
      );

      final dados = jsonDecode(resposta.body);

      if (!mounted) return;

      setState(() {
        if (dados.containsKey('id')) {
          id = int.parse(dados['id'].toString());
          fotoSalva = '$servidor/${dados['arquivo']}';
          descricaoSalva = dados['descricao'] ?? '';
          mensagem = '';
        } else {
          mensagem = 'Não há mais fotos!';
        }
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        mensagem = 'Erro ao consultar fotos!';
      });
    }
  }

  // Voltar para a primeira foto
  void reiniciar() {
    setState(() {
      id = 0;
      fotoSalva = '';
      descricaoSalva = '';
      mensagem = '';
    });

    proximo();
  }

  @override
  void initState() {
    super.initState();
    proximo();
  }

  @override
  void dispose() {
    controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Cadastro de Fotos'),
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
                onPressed: () =>
                    escolherFoto(ImageSource.camera),
                child: const Text('Tirar foto'),
              ),

              ElevatedButton(
                onPressed: () =>
                    escolherFoto(ImageSource.gallery),
                child: const Text('Escolher da galeria'),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: controlador,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Digite a descrição da foto',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: salvar,
                child: const Text('Salvar foto'),
              ),

              const Divider(height: 40),

              const Text(
                'Fotos Salvas',
                style: TextStyle(fontSize: 22),
              ),

              const SizedBox(height: 15),

              Text('ID: $id'),

              const SizedBox(height: 10),

              if (fotoSalva.isNotEmpty)
                Image.network(
                  fotoSalva,
                  height: 220,
                  errorBuilder: (context, erro, stack) {
                    return const Text('Erro ao carregar imagem');
                  },
                ),

              const SizedBox(height: 10),

              Text(
                descricaoSalva,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 15),

              ElevatedButton(
                onPressed: proximo,
                child: const Text('Próxima foto'),
              ),

              ElevatedButton(
                onPressed: reiniciar,
                child: const Text('Voltar ao início'),
              ),

              const SizedBox(height: 15),

              Text(mensagem),
            ],
          ),
        ),
      ),
    );
  }
}
