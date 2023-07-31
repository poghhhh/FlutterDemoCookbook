class InfomationModel {
  String name;
  String role;

  InfomationModel({required this.name, required this.role});

  factory InfomationModel.fromJson(Map<String, dynamic> json) {
    return InfomationModel(name: json['name'], role: json['role']);
  }
}
