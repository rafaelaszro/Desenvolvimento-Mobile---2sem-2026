
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

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

  final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    lerTexto();
  }

  // Acessa a pasta de documentos do aplicativo
  Future<String> get _pastaDocumentos async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  // Cria a referência ao arquivo organiza.md
  Future<File> get _arquivo async {
    final caminho = await _pastaDocumentos;
    return File('$caminho/organiza.md');
  }

  // Salva o texto no arquivo Markdown
  Future<void> salvarTexto() async {
    try {
      final arquivo = await _arquivo;

      await arquivo.writeAsString(controlador.text);

      mostrarMensagem('Texto salvo com sucesso!');
      print('Arquivo salvo: ${arquivo.path}');
    } catch (e) {
      mostrarMensagem('Erro ao salvar o arquivo!');
      print('Erro: $e');
    }
  }

  // Lê o texto salvo anteriormente
  Future<void> lerTexto() async {
    try {
      final arquivo = await _arquivo;

      if (await arquivo.exists()) {
        final conteudo = await arquivo.readAsString();

        if (!mounted) return;

        setState(() {
          controlador.text = conteudo;
        });
      }
    } catch (e) {
      mostrarMensagem('Erro ao ler o arquivo!');
      print('Erro: $e');
    }
  }

  // Apaga o arquivo e limpa o campo de texto
  Future<void> apagarTexto() async {
    try {
      final arquivo = await _arquivo;

      if (await arquivo.exists()) {
        await arquivo.delete();
      }

      if (!mounted) return;

      setState(() {
        controlador.clear();
      });

      mostrarMensagem('Texto apagado com sucesso!');
    } catch (e) {
      mostrarMensagem('Erro ao apagar o arquivo!');
      print('Erro: $e');
    }
  }

  // Mostra mensagens na tela
  void mostrarMensagem(String mensagem) {
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(mensagem),
        duration: const Duration(seconds: 2),
      ),
    );
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
      scaffoldMessengerKey: messengerKey,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Editor Markdown'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Arquivo: organiza.md',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Expanded(
                child: TextField(
                  controller: controlador,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    hintText: 'Digite seu texto Markdown aqui...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: salvarTexto,
                      child: const Text('Salvar'),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: ElevatedButton(
                      onPressed: apagarTexto,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Apagar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
