
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  final TextEditingController controladorCep = TextEditingController();
  final TextEditingController controladorNumero = TextEditingController();

  String rua = '';
  String bairro = '';
  String cidade = '';
  String estado = '';

  bool carregando = false;

  @override
  void initState() {
    super.initState();
    buscarDados();
  }

  // Recupera os dados salvos anteriormente
  Future<void> buscarDados() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      controladorCep.text = prefs.getString('cep') ?? '';
      controladorNumero.text = prefs.getString('numero') ?? '';
      rua = prefs.getString('rua') ?? '';
      bairro = prefs.getString('bairro') ?? '';
      cidade = prefs.getString('cidade') ?? '';
      estado = prefs.getString('estado') ?? '';
    });
  }

  // Consulta o endereço usando a API ViaCEP
  Future<void> buscarCep() async {
    String cep = controladorCep.text.replaceAll(RegExp(r'\D'), '');

    if (cep.length != 8) {
      mostrarMensagem('Digite um CEP válido!');
      return;
    }

    setState(() {
      carregando = true;
      rua = '';
      bairro = '';
      cidade = '';
      estado = '';
    });

    try {
      final resposta = await http.get(
        Uri.parse('https://viacep.com.br/ws/$cep/json/'),
      );

      if (resposta.statusCode == 200) {
        final dados = jsonDecode(resposta.body);

        if (dados['erro'] == true) {
          mostrarMensagem('CEP não encontrado!');
          return;
        }

        if (!mounted) return;

        setState(() {
          rua = dados['logradouro'] ?? '';
          bairro = dados['bairro'] ?? '';
          cidade = dados['localidade'] ?? '';
          estado = dados['uf'] ?? '';
        });

        mostrarMensagem('Endereço encontrado!');
      } else {
        mostrarMensagem('Erro ao consultar CEP!');
      }
    } catch (e) {
      mostrarMensagem('Erro de conexão ao consultar o CEP!');
      debugPrint('Erro: $e');
    } finally {
      if (mounted) {
        setState(() {
          carregando = false;
        });
      }
    }
  }

  // Salva os dados utilizando shared_preferences
  Future<void> salvar() async {
    if (controladorCep.text.trim().isEmpty ||
        controladorNumero.text.trim().isEmpty ||
        cidade.isEmpty ||
        estado.isEmpty) {
      mostrarMensagem('Preencha o CEP, número e consulte o endereço!');
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('cep', controladorCep.text);
    await prefs.setString('numero', controladorNumero.text);
    await prefs.setString('rua', rua);
    await prefs.setString('bairro', bairro);
    await prefs.setString('cidade', cidade);
    await prefs.setString('estado', estado);

    mostrarMensagem('Dados salvos com sucesso!');
  }

  // Remove todos os dados salvos
  Future<void> remover() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('cep');
    await prefs.remove('numero');
    await prefs.remove('rua');
    await prefs.remove('bairro');
    await prefs.remove('cidade');
    await prefs.remove('estado');

    if (!mounted) return;

    setState(() {
      controladorCep.clear();
      controladorNumero.clear();
      rua = '';
      bairro = '';
      cidade = '';
      estado = '';
    });

    mostrarMensagem('Dados removidos com sucesso!');
  }

  // Exibe mensagens sem erro de ScaffoldMessenger
  void mostrarMensagem(String mensagem) {
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(mensagem),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  void dispose() {
    controladorCep.dispose();
    controladorNumero.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Correção do erro ScaffoldMessenger
      scaffoldMessengerKey: messengerKey,

      home: Scaffold(
        appBar: AppBar(
          title: const Text('Consulta de CEP'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Consultar Endereço',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: controladorCep,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'CEP',
                  hintText: 'Digite seu CEP',
                  border: OutlineInputBorder(),
                ),
                onChanged: (_) {
                  setState(() {
                    rua = '';
                    bairro = '';
                    cidade = '';
                    estado = '';
                  });
                },
              ),

              const SizedBox(height: 15),

              TextField(
                controller: controladorNumero,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Número da casa',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: carregando ? null : buscarCep,
                child: Text(
                  carregando ? 'Buscando...' : 'Buscar CEP',
                ),
              ),

              const SizedBox(height: 25),

              const Text(
                'Dados do Endereço',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Text('Rua: $rua'),
              const SizedBox(height: 8),

              Text('Bairro: $bairro'),
              const SizedBox(height: 8),

              Text('Cidade: $cidade'),
              const SizedBox(height: 8),

              Text('Estado: $estado'),
              const SizedBox(height: 8),

              Text('Número: ${controladorNumero.text}'),

              const SizedBox(height: 25),

              ElevatedButton(
                onPressed: carregando ? null : salvar,
                child: const Text('Salvar'),
              ),

              const SizedBox(height: 10),

              ElevatedButton(
                onPressed: carregando ? null : remover,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Remover'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
