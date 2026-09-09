class Pergunta {
  const Pergunta(
    this.texto,
    this.respostas,
    this.respostaCorreta,
  );

  final String texto;
  final List<String> respostas;
  final String respostaCorreta;

  List<String> embaralha() {
    final listaEmbaralhada = List.of(respostas);
    listaEmbaralhada.shuffle();
    return listaEmbaralhada;
  }
}