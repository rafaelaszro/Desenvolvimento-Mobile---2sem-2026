import 'package:flutter/material.dart';
import 'package:flutter_application_2/pergunta.dart';
import 'package:flutter_application_2/questoes.dart';

class Janela2 extends StatelessWidget {
  const Janela2({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Pergunta teste1 = questoes[2];

    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Opacity(
              opacity: 0.8,
              child: Image.asset(
                'assets/imagens/palhaco_ouve.png',
              ),
            ),
          ),
          Text(teste1.texto),
          const SizedBox(
            height: 10,
          ),
          ...teste1.respostas.map((resposta) {
            return Column(
              children: [
                NovoBotao(
                  chamada: () {
                    if (resposta == teste1.respostas[1]) {
                      print('Acertou!');
                    } else {
                      print('Errou!');
                    }
                  },
                  texto: resposta,
                ),
                const SizedBox(height: 10),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class NovoBotao extends StatelessWidget {
  const NovoBotao({
    super.key,
    required this.texto,
    required this.chamada,
  });

  final String texto;
  final Function() chamada;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: chamada,
      child: Text(texto),
    );
  }
}
