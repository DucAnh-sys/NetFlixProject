class Notificationmodel {
  final String title;
  final String description;
  final String image;

  Notificationmodel(this.title, this.description, this.image);

  static List<Notificationmodel> listNotification(){
    return [
      Notificationmodel("Stranger Things", "Cậu bé mất tích là một loạt phim truyền hình chiếu mạng thể loại khoa học viễn tưởng – kinh dị Mỹ do Anh em nhà Duffer sáng tạo và được phát hành trên Netflix.", "assets/images/StrangeThings.webp"),
      Notificationmodel("Stranger Things", "Cậu bé mất tích là một loạt phim truyền hình chiếu mạng thể loại khoa học viễn tưởng – kinh dị Mỹ do Anh em nhà Duffer sáng tạo và được phát hành trên Netflix.", "assets/images/StrangeThings.webp"),
      Notificationmodel("Stranger Things", "Cậu bé mất tích là một loạt phim truyền hình chiếu mạng thể loại khoa học viễn tưởng – kinh dị Mỹ do Anh em nhà Duffer sáng tạo và được phát hành trên Netflix.", "assets/images/StrangeThings.webp"),
      Notificationmodel("Stranger Things", "Cậu bé mất tích là một loạt phim truyền hình chiếu mạng thể loại khoa học viễn tưởng – kinh dị Mỹ do Anh em nhà Duffer sáng tạo và được phát hành trên Netflix.", "assets/images/StrangeThings.webp"),
    ];
  }
}