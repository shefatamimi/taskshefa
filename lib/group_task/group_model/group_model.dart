class GroupModel {
  final String? id;
  final String userId;
  final String title;
  final String description;

  GroupModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
  });

  factory GroupModel.fromJson(
      Map<String, dynamic> map,
      ) {
    return GroupModel(
      id: map['id'],
      userId: map['userId'],
      title: map['title'],
      description: map['description'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
    };
  }
}