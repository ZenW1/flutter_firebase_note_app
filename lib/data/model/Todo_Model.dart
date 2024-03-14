class TodoModel {
  late final String id;
  late final String title;
  late final String type;
  late final String category;
  late final String dateTime;
  late final String remindTime;
  late final String color;
  late final String description;

  TodoModel({
    required this.id,
    required this.title,
    required this.type,
    required this.category,
    required this.dateTime,
    required this.remindTime,
    required this.color,
    required this.description,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      type: json['type'] ?? '',
      category: json['category'] ?? '',
      dateTime: json['dateTime'] ?? '',
      description: json['description'] ?? '',
      remindTime: json['remindTime'] ?? '',
      color: json['color'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'type': type,
      'category': category,
      'dateTime': dateTime,
      'description': description,
      'remindTime': remindTime,
      'color': color,
    };
  }
}
