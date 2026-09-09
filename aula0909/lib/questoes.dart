import 'package:flutter_application_2/pergunta.dart';

const questoes = [
  Pergunta(
    'Qual comando atualiza um dado em SQL?',
    ['INSERT', 'UPDATE', 'DELETE', 'DROP'],
    'UPDATE',
  ),

  Pergunta(
    'Qual comando apaga uma tabela?',
    ['DELETE', 'DROP', 'SELECT', 'INSERT'],
    'DROP',
  ),

  Pergunta(
    'O que a cláusula WHERE faz?',
    [
      'Cria uma tabela.',
      'Adiciona condições em um comando.',
      'Apaga registros.',
      'Consulta todos os dados de uma tabela.',
    ],
    'Adiciona condições em um comando.',
  ),

  Pergunta(
    'Qual comando SQL é utilizado para consultar ou recuperar dados de uma tabela?',
    ['INSERT', 'UPDATE', 'SELECT', 'DELETE'],
    'SELECT',
  ),

  Pergunta(
    'Qual é a estrutura básica correta para iniciar a inclusão de um novo registro em uma tabela chamada usuarios?',
    [
      'ADD into usuarios',
      'INSERT into usuarios',
      'UPDATE usuarios SET',
      'SELECT FROM usuarios',
    ],
    'INSERT into usuarios',
  ),
];