import 'package:flutter/material.dart';
import 'package:flutter_application_2/pergunta.dart';
import 'package:flutter_application_2/questoes.dart';

import 'botao_resposta.dart';

class Janela2 extends StatefulWidget {
  const Janela2({super.key});

  @override
  State<Janela2> createState() => _Janela2State();
}

class _Janela2State extends State<Janela2> {
  int perguntaAtual = 0;
  bool finalizado = false;

  @override
  Widget build(BuildContext context) {

    if (finalizado) {
      return Scaffold(
        body: Center(
          child: Text(
            'Parabéns! Você terminou o quiz!',
            style: TextStyle(fontSize: 24),
          ),
        ),
      );
    }

    Pergunta teste1 = questoes[perguntaAtual];

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

          ...teste1.embaralha().map((item) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: BotaoReposta(
                cor: Color.fromARGB(255, 224, 55, 47),

                callResposta: () {
                  if (item == teste1.respostaCorreta) 
                  {
                    print('Acertou!');
                    print('Item correto: $item');
                    setState(() {
                      if (perguntaAtual < questoes.length - 1) {
                        perguntaAtual = perguntaAtual + 1;
                      } else {
                        finalizado = true;
                      }
                    });
                  } else {
                    print('Errou!');
                    print('Item escolhido: $item');
                  }
                },

                textoResposta: item,
              ),
            );
          }),
        ],
      ),
    );
  }
}