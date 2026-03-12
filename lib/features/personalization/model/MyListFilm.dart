class Mylistfilm {
  final String title;
  final String image;

  Mylistfilm(this.title, this.image);

  static List<Mylistfilm> listMyFilm(){
    return [
      Mylistfilm("Stranger Things", "assets/images/StrangeThings.webp"),
      Mylistfilm("Stranger Things", "assets/images/StrangeThings.webp"),
      Mylistfilm("Stranger Things", "assets/images/StrangeThings.webp"),
      Mylistfilm("Stranger Things", "assets/images/StrangeThings.webp"),
      Mylistfilm("Stranger Things", "assets/images/StrangeThings.webp"),
      Mylistfilm("Stranger Things", "assets/images/StrangeThings.webp"),
      Mylistfilm("Stranger Things", "assets/images/StrangeThings.webp"),
      Mylistfilm("Stranger Things", "assets/images/StrangeThings.webp"),
      Mylistfilm("Stranger Things", "assets/images/StrangeThings.webp"),
    ];
  }
}