
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  String texto = '';
  int id = 0;

  String servidor = 'http://10.106.76.11/aula13';

  void salvar() async {
    if (controlador.text.isEmpty) return;

    await http.post(
      Uri.parse('$servidor/index.php'),
      body: {'texto': controlador.text},
    );

    controlador.clear();
  }

  void proximo() async {
    final resposta = await http.get(
      Uri.parse('$servidor/consultar.php?id=$id'),
    );

    final dados = jsonDecode(resposta.body);

    setState(() {
      if (dados.containsKey('id')) {
        id = int.parse(dados['id'].toString());
        texto = dados['texto'];
      } else {
        texto = 'Não há mais textos.';
      }
    });
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
          title: const Text('Textos PHP'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Text('Cadastrar Texto'),

              TextField(
                controller: controlador,
                decoration: const InputDecoration(
                  hintText: 'Digite um texto',
                  border: OutlineInputBorder(),
                ),
              ),

              ElevatedButton(
                onPressed: salvar,
                child: const Text('Salvar'),
              ),

              const SizedBox(height: 30),

              const Text('Consultar Textos'),

              Text('ID: $id'),
              Text(texto),

              ElevatedButton(
                onPressed: proximo,
                child: const Text('Próximo texto'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
