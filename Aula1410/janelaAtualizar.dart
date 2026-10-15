
import 'package:flutter/material.dart';
import 'package:aula1410/helper.dart';

class JanelaAtualizar extends StatefulWidget {
  const JanelaAtualizar({super.key});

  @override
  State<JanelaAtualizar> createState() => _JanelaAtualizarState();
}

class _JanelaAtualizarState extends State<JanelaAtualizar> {
  TextEditingController controlaId = TextEditingController();
  TextEditingController controlaNome = TextEditingController();
  TextEditingController controlaIdade = TextEditingController();

  Future<void> atualizarNoBanco() async {
    int? id = int.tryParse(controlaId.text);

    if (id == null) {
      print('Informe um ID válido!');
      return;
    }

    Map<String, dynamic> dados = {
      'nome': controlaNome.text,
      'idade': int.tryParse(controlaIdade.text) ?? 0,
    };

    int resultado = await DatabaseHelper.atualizarCao(id, dados);

    if (resultado > 0) {
      print('Pet atualizado!');
    } else {
      print('Pet não encontrado!');
    }

    setState(() {
      controlaId.text = '';
      controlaNome.text = '';
      controlaIdade.text = '';
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controlaNome,
              decoration: InputDecoration(
                labelText: 'Novo nome do pet',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: controlaIdade,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Nova idade do pet',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              atualizarNoBanco();
            },
            child: Text('Atualizar'),
          ),
        ],
      ),
    );
  }
}
