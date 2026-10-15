
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:aula1410/janelaSalvar.dart';
import 'package:aula1410/janelaListar.dart';
import 'package:aula1410/janelaExcluir.dart';
import 'package:aula1410/janelaAtualizar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }

  runApp(const MyWidget());
}

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Cadastro de Pets'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Salvar'),
                Tab(text: 'Listar'),
                Tab(text: 'Atualizar'),
                Tab(text: 'Apagar'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              JanelaSalvar(),
              JanelaListar(),
              JanelaAtualizar(),
              JanelaExcluir(),
            ],
          ),
        ),
      ),
    );
  }
}
