import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

// 1. CLASSE HELPER PARA GERENCIAR O BANCO DE DADOS
class DatabaseHelper {
  static Database? _database;

  // Garante que o banco seja inicializado e retorna a conexão ativa
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Cria o arquivo do banco no dispositivo e define a tabela
  static Future<Database> _initDatabase() async {
    String path = '';

    if (Platform.isWindows || Platform.isLinux) {
      final databaseFactory = databaseFactoryFfi;
      final caminhoBanco = await databaseFactory.getDatabasesPath();
      path = join(caminhoBanco, 'banco_pets.db');
    } else {
      String caminhoBanco = await getDatabasesPath();
      path = join(caminhoBanco, 'banco_pets.db');
    }

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE caes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT,
            dono TEXT,
            idade INTEGER
          )
        ''');
      },
    );
  }

  // Insere um pet no banco
  static Future<int> inserirCao(Map<String, dynamic> dados) async {
    final db = await DatabaseHelper.database;
    return await db.insert('caes', dados);
  }

  // Lista os pets cadastrados
  static Future<List<Map<String, dynamic>>> listarCaes() async {
    final db = await DatabaseHelper.database;
    return await db.query('caes');
  }

  // Atualiza um pet pelo ID
  static Future<int> atualizarCao(
      int id, Map<String, dynamic> dados) async {
    final db = await DatabaseHelper.database;

    return await db.update(
      'caes',
      dados,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // Apaga um pet pelo ID
  static Future<int> apagarCao(int id) async {
    final db = await DatabaseHelper.database;

    return await db.delete(
      'caes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
