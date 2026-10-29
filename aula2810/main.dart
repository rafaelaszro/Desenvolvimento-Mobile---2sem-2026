
import 'package:flutter/material.dart';
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

  int fator = 1;
  int multiplicador = 1;
  String resposta = '';

  bool aguardando = false;
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    buscarProgresso();
  }

  // Recupera a posição salva
  Future<void> buscarProgresso() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      fator = (prefs.getInt('fator') ?? 1).clamp(1, 10);
      multiplicador = (prefs.getInt('multiplicador') ?? 1).clamp(1, 10);
      carregando = false;
    });
  }

  // Salva a posição atual
  Future<void> salvarProgresso() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('fator', fator);
    await prefs.setInt('multiplicador', multiplicador);
  }

  // Adiciona o número digitado
  void digitarNumero(int numero) {
    if (aguardando) return;

    setState(() {
      if (resposta.length < 3) {
        resposta += numero.toString();
      }
    });
  }

  // Apaga o último número digitado
  void apagarNumero() {
    if (aguardando || resposta.isEmpty) return;

    setState(() {
      resposta = resposta.substring(0, resposta.length - 1);
    });
  }

  // Limpa toda a resposta
  void limparResposta() {
    if (aguardando) return;

    setState(() {
      resposta = '';
    });
  }

  // Verifica a resposta
  void verificar() {
    if (aguardando || carregando) return;

    int? numero = int.tryParse(resposta);

    if (numero == null) {
      mostrarMensagem('Digite um número!');
      return;
    }

    if (numero == fator * multiplicador) {
      setState(() {
        resposta = '';

        if (multiplicador < 10) {
          multiplicador++;
        } else {
          proximoFator();
        }
      });

      salvarProgresso();
    } else {
      setState(() {
        aguardando = true;
      });

      final fatorErro = fator;
      bool continuarMesmoFator = false;

      final messenger = messengerKey.currentState!;
      messenger.hideCurrentSnackBar();

      final controle = messenger.showSnackBar(
        SnackBar(
          content: const Text(
            'Errou, clique aqui para continuar.',
          ),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Continuar',
            onPressed: () {
              continuarMesmoFator = true;

              setState(() {
                fator = fatorErro;
                multiplicador = 1;
                resposta = '';
                aguardando = false;
              });

              salvarProgresso();
            },
          ),
        ),
      );

      controle.closed.then((_) {
        if (!mounted || continuarMesmoFator) return;

        setState(() {
          proximoFator();
          resposta = '';
          aguardando = false;
        });

        salvarProgresso();
      });
    }
  }

  // Avança para a próxima tabuada
  void proximoFator() {
    fator++;

    if (fator > 10) {
      fator = 1;
    }

    multiplicador = 1;
  }

  // Exibe mensagens na tela
  void mostrarMensagem(String mensagem) {
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(mensagem),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // Cria os botões numéricos
  Widget botaoNumero(int numero) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: ElevatedButton(
          onPressed: aguardando
              ? null
              : () => digitarNumero(numero),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 18),
          ),
          child: Text(
            '$numero',
            style: const TextStyle(fontSize: 22),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double progresso = (multiplicador - 1) / 10;

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      scaffoldMessengerKey: messengerKey,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Jogo da Tabuada'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: carregando
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 400,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        Text(
                          'Tabuada do $fator',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          '$fator x $multiplicador = ?',
                          style: const TextStyle(fontSize: 32),
                        ),

                        const SizedBox(height: 25),

                        Text(
                          'Progresso: ${(progresso * 100).toInt()}%',
                        ),

                        const SizedBox(height: 10),

                        LinearProgressIndicator(
                          value: progresso,
                          minHeight: 12,
                          borderRadius: BorderRadius.circular(8),
                        ),

                        const SizedBox(height: 25),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            resposta.isEmpty ? '0' : resposta,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 32),
                          ),
                        ),

                        const SizedBox(height: 15),

                        Row(
                          children: [
                            botaoNumero(1),
                            botaoNumero(2),
                            botaoNumero(3),
                          ],
                        ),

                        Row(
                          children: [
                            botaoNumero(4),
                            botaoNumero(5),
                            botaoNumero(6),
                          ],
                        ),

                        Row(
                          children: [
                            botaoNumero(7),
                            botaoNumero(8),
                            botaoNumero(9),
                          ],
                        ),

                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed:
                                    aguardando ? null : limparResposta,
                                child: const Text('C'),
                              ),
                            ),

                            botaoNumero(0),

                            Expanded(
                              child: ElevatedButton(
                                onPressed:
                                    aguardando ? null : apagarNumero,
                                child: const Icon(Icons.backspace),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: aguardando ? null : verificar,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(15),
                            ),
                            child: const Text(
                              'Verificar',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
