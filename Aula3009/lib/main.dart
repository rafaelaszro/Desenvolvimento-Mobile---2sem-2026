import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Postagem> buscaPostagem(String cep) async {
  final resposta = await http.get(
    Uri.parse('https://viacep.com.br/ws/$cep/json/'),
    headers: {'Accept': 'application/json'},
  );

  if (resposta.statusCode == 200) {
    return Postagem.fromJson(
      jsonDecode(resposta.body) as Map<String, dynamic>,
    );
  } else {
    throw Exception('Falha ao carregar CEP.');
  }
}

class Postagem {
  final String logradouro;
  final String localidade;
  final String bairro;
  final String uf;

  const Postagem({
    required this.logradouro,
    required this.localidade,
    required this.bairro,
    required this.uf,
  });

  factory Postagem.fromJson(Map<String, dynamic> json) {
    return Postagem(
      logradouro: json['logradouro'] ?? '',
      localidade: json['localidade'] ?? '',
      bairro: json['bairro'] ?? '',
      uf: json['uf'] ?? '',
    );
  }
}

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController cepController = TextEditingController();

  Future<Postagem>? postFuturo;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Buscando dados',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Buscando dados'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: cepController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Digite o CEP',
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  setState(() {
                    postFuturo = buscaPostagem(cepController.text);
                  });
                },
                child: const Text('Buscar'),
              ),

              const SizedBox(height: 20),

              if (postFuturo != null)
                FutureBuilder<Postagem>(
                  future: postFuturo,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        '${snapshot.data!.logradouro}\n\n'
                        '${snapshot.data!.bairro}\n\n'
                        '${snapshot.data!.localidade}\n\n'
                        '${snapshot.data!.uf}',
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    }

                    return const CircularProgressIndicator();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}