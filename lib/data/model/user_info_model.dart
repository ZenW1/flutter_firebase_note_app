class UserInfoModel {
  late final String title;
  late final String id;
  late final String category;
  late final String type;
  late final String color;
  late final String description;
  late final String remindTime;
  late final String dateTime;

  UserInfoModel({
    required this.title,
    required this.id,
    required this.category,
    required this.type,
    required this.color,
    required this.description,
    required this.remindTime,
    required this.dateTime,
  });

  UserInfoModel.fromMap(Map<String, dynamic> data) {
    title = data['title'] ?? '';
    id = data['id'] ?? '';
    category = data['category'] ?? '';
    type = data['type'] ?? '';
    color = data['color'] ?? '';
    description = data['description'] ?? '';
    remindTime = data['remindTime'] ?? '';
    dateTime = data['dateTime'] ?? '';
  }
}
