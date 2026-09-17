import 'dart:math';

class TabuadaControle {
  int numero1 = 0;
  int numero2 = 0;

  TabuadaControle() {
    gerarNovaConta();
  }

  void gerarNovaConta() {
    final random = Random();
    numero1 = random.nextInt(10) + 1;
    numero2 = random.nextInt(10) + 1;
  }

  String get pergunta => '$numero1 x $numero2 = ?';

  int get resultadoCorreto => numero1 * numero2;

  bool verificarResposta(String textoDigitado) {
    int? respostaUsuario = int.tryParse(textoDigitado);
    return respostaUsuario == resultadoCorreto;
  }
}
