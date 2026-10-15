
import 'package:flutter/material.dart';
import 'package:aula1410/helper.dart';

class JanelaExcluir extends StatefulWidget {
  const JanelaExcluir({super.key});

  @override
  State<JanelaExcluir> createState() => _JanelaExcluirState();
}

class _JanelaExcluirState extends State<JanelaExcluir> {
  TextEditingController controlaId = TextEditingController();

  Future<void> apagarNoBanco() async {
    int? id = int.tryParse(controlaId.text);

    if (id == null) {
      print('Informe um ID válido!');
      return;
    }

    int resultado = await DatabaseHelper.apagarCao(id);

    if (resultado > 0) {
      print('Pet apagado!');
    } else {
      print('Pet não encontrado!');
    }

    setState(() {
      controlaId.text = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controlaId,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'ID do pet',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              apagarNoBanco();
            },
            child: Text('Apagar'),
          ),
        ],
      ),
    );
  }
}
