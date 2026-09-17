import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'imagem_controle.dart';

void main() {
  runApp(const Janela());
}

class Janela extends StatelessWidget {
  const Janela({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: Principal()),
    );
  }
}

class Principal extends StatefulWidget {
  const Principal({super.key});

  @override
  State<Principal> createState() => _PrincipalState();
}

class _PrincipalState extends State<Principal> {
  ImagemControle controle = ImagemControle();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            controle.imagemAtual.titulo,
            style: GoogleFonts.montserrat(fontSize: 28),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Image.network(
            controle.imagemAtual.url,
            width: 200,
          ),
          const SizedBox(height: 10),
          
          GestureDetector(
            onTap: () {
              setState(() {
                controle.imagemAtual.mudaLike();
              });
            },
            child: Icon(
              controle.imagemAtual.liked ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
              size: 30,
            ),
          ),
          const SizedBox(height: 20),

          ElevatedButton(
            onPressed: () {
              setState(() {
                controle.proximaImagem();
              });
            },
            child: const Text('Próxima'),
          ),
        ],
      ),
    );
  }
}
