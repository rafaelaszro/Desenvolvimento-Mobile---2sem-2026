class Pergunta {
  const Pergunta(this.texto, this.respostas);

  final String texto;
  final List<String> respostas;

  List<String> embaralha() {
    final listaEmbaralhada = List.of(respostas);
    listaEmbaralhada.shuffle();
    return listaEmbaralhada;
  }
}
