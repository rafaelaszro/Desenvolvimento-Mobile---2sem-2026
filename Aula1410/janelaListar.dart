
import 'package:flutter/material.dart';
import 'package:aula1410/helper.dart';

class JanelaListar extends StatefulWidget {
  const JanelaListar({super.key});

  @override
  State<JanelaListar> createState() => _JanelaListarState();
}

class _JanelaListarState extends State<JanelaListar> {
  List<Map<String, dynamic>> listaCaes = [];

  @override
  void initState() {
    super.initState();
    carregarCaes();
  }

  Future<void> carregarCaes() async {
    final caes = await DatabaseHelper.listarCaes();

    if (!mounted) return;

    setState(() {
      listaCaes = caes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            carregarCaes();
          },
          child: Text('Listar'),
        ),
        SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: listaCaes.length,
            itemBuilder: (context, index) {
              final cao = listaCaes[index];

              return ListTile(
                title: Text('Nome: ${cao['nome']}'),
                subtitle: Text(
                  'ID: ${cao['id']}\n'
                  'Idade: ${cao['idade']} anos',
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
