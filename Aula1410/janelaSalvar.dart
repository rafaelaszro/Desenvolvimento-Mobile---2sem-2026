
import 'package:flutter/material.dart';
import 'package:aula1410/helper.dart';

class JanelaSalvar extends StatefulWidget {
  const JanelaSalvar({super.key});

  @override
  State<JanelaSalvar> createState() => _JanelaSalvarState();
}

class _JanelaSalvarState extends State<JanelaSalvar> {
  TextEditingController controlaNome = TextEditingController();
  TextEditingController controlaIdade = TextEditingController();

  Future<void> salvarNoBanco() async {
    Map<String, dynamic> novoCao = {
      'nome': controlaNome.text,
      'idade': int.tryParse(controlaIdade.text) ?? 0,
    };

    await DatabaseHelper.inserirCao(novoCao);

    print('${controlaNome.text} salvo!');

    setState(() {
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
              controller: controlaNome,
              decoration: InputDecoration(
                labelText: 'Nome do pet',
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
                labelText: 'Idade do pet',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              salvarNoBanco();
            },
            child: Text('Salvar'),
          ),
        ],
      ),
    );
  }
}
