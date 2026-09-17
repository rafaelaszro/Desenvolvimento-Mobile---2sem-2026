class ImagemModelo {
  final String url;
  final String titulo;
  bool like = false; 

  ImagemModelo({required this.url, required this.titulo});
  bool get liked => like;

  void mudaLike() {
    like = !like;
  }
}

class ImagemControle {
  final List<ImagemModelo> imagens = [
    ImagemModelo(
      url: 'https://thumb.wikimedia.org/wikipedia/commons/thumb/d/de/Wikipedia_Logo_1.0.png/960px-Wikipedia_Logo_1.0.png?utm_source=pt.wikipedia.org&utm_campaign=index&utm_content=thumbnail',
      titulo: 'Ficheiro logo',
    ),
    ImagemModelo(
      url: 'https://thumb.wikimedia.org/wikipedia/commons/thumb/a/a1/Flag_of_the_President_of_Brazil.svg/250px-Flag_of_the_President_of_Brazil.svg.png?utm_source=pt.wikipedia.org&utm_campaign=parser&utm_content=thumbnail',
      titulo: 'Bandeira presidencial do Brasil',
    ),
    ImagemModelo(
      url: 'https://minecraft.wiki/images/thumb/Zombie_JE5_BE2.png/295px-Zombie_JE5_BE2.png?d709c',
      titulo: 'Zombie Minecraft',
    ),
    ImagemModelo(
      url: 'https://thumb.wikimedia.org/wikipedia/commons/thumb/5/5c/P%C3%AAche_et_aquaculture_%28tonnes%29_en_Afrique_en_2000.png/250px-P%C3%AAche_et_aquaculture_%28tonnes%29_en_Afrique_en_2000.png?utm_source=pt.wikipedia.org&utm_campaign=parser&utm_content=thumbnail',
      titulo: 'Mapa da África',
    ),
    ImagemModelo(
      url: 'https://thumb.wikimedia.org/wikipedia/commons/thumb/5/5e/Bet_Giyorgis_church_Lalibela_01.jpg/250px-Bet_Giyorgis_church_Lalibela_01.jpg?utm_source=pt.wikipedia.org&utm_campaign=parser&utm_content=thumbnail',
      titulo: 'Igreja São Jorge',
    ),
  ];

  int atual = 0;

  ImagemModelo get imagemAtual => imagens[atual];

  void proximaImagem() {
    if (atual < imagens.length - 1) {
      atual++;
    } else {
      atual = 0;
    }
  }
}
