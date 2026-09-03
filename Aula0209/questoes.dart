import 'package:flutter_application_2/pergunta.dart';

const questoes = [
  Pergunta('Qual comando atualiza um dado em SQL?',
      ['INSERT', 'UPDATE', 'DELETE', 'DROP']),
  Pergunta(
      'Qual comando apaga uma tabela?', ['DELETE', 'DROP', 'SELECT', 'INSERT']),
  Pergunta('O que a cláusula WHERE faz?', [
    'Cria uma tabela.',
    'Adiciona condições em um comando.',
    'Apaga registros.',
    'Consulta todos os dados de uma tabela.'
  ]),
];
