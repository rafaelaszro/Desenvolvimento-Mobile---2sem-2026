import 'frase_modelo.dart';

class FraseControle {
  final List<FraseModelo> frases = [
    FraseModelo(texto: 'Penso, logo existo.',autor: 'René Descartes',),
    FraseModelo(texto: 'Só sei que nada sei.',autor: 'Sócrates',),
    FraseModelo(texto:'Um pequeno passo para o homem, um salto gigante para a humanidade.',
      autor: 'Neil Armstrong',),];

  int atual = 0;
  FraseModelo get fraseAtual => frases[atual];

  void proximaFrase() {
    if (atual < frases.length - 1) {
      atual++;
    } else {
      atual = 0;
    }
  }

  void alterarLike() {
    fraseAtual.like = !fraseAtual.like;
  }
}