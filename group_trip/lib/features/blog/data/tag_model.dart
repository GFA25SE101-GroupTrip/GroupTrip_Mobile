class TagModel {
  final String id;
  final String name;
  final String description;
 
  TagModel({
    required this.id,
    required this.name,
    required this.description,
  });
  
  factory TagModel.fromJson(Map<String, dynamic> json) {
    return TagModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
    };
  }
}