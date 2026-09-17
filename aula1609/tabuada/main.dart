import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'tabuada_controle.dart';

void main() {
  runApp(const Janela());
}

class Janela extends StatelessWidget {
  const Janela({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Principal(),
        ),
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
  TabuadaControle controle = TabuadaControle();
  final controlaTexto = TextEditingController();
  String respostaDigitada = '';

  @override
  Widget build(BuildContext context) {
    bool estaCorreto = controle.verificarResposta(respostaDigitada);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            controle.pergunta,
            style: GoogleFonts.montserrat(
                fontSize: 40, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          if (respostaDigitada.isNotEmpty)
            Icon(
              estaCorreto ? Icons.check_circle : Icons.cancel,
              color: estaCorreto ? Colors.green : Colors.red,
              size: 60,
            )
          else
            const SizedBox(height: 60),
          const SizedBox(height: 20),
          TextField(
            controller: controlaTexto,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                respostaDigitada = value;
              });
            },
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Digite o resultado...',
              labelText: 'Sua Resposta',
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              setState(() {
                controle.gerarNovaConta();
                controlaTexto.clear();
                respostaDigitada = '';
              });
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text('Próxima Conta', style: TextStyle(fontSize: 18)),
          ),
        ],
      ),
    );
  }
}
