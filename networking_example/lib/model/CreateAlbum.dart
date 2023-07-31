class CreateAlbum {
  final int id;
  final String title;

  const CreateAlbum({required this.id, required this.title});

  factory CreateAlbum.fromJson(Map<String, dynamic> json) {
    return CreateAlbum(
      id: json['id'],
      title: json['title'],
    );
  }
}
