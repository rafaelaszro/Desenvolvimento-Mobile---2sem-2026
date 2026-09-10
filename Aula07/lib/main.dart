import 'package:flutter/material.dart';
import 'frase_controle.dart';

void main() {
  runApp(const Janela());
}

class Janela extends StatelessWidget {
  const Janela({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        body: Principal(),
      ),
    );
  }
}

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  final FraseControle controle = FraseControle();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(controle.fraseAtual.texto, ),
        Text(controle.fraseAtual.autor,),
        IconButton(
          onPressed: () {
            setState(() {
              controle.alterarLike();
            });
          },
          icon: Icon(
            controle.fraseAtual.like
                ? Icons.favorite
                : Icons.favorite_border,
          ),
        ),

        ElevatedButton(
          onPressed: () {
            setState(() {
              controle.proximaFrase();
            });
          },
          child: const Text('Próxima'),
        ),

      ],
    );
  }
}