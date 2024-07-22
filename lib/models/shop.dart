import 'entity.dart';

class Shop extends Entity {
  final String userId;

  final String name;
  final String email;

  //ignore: prefer_constructors_over_static_methods
  static Shop fromJson(Map<String, dynamic> json) {
    return Shop(
      userId: json['_id'],
      email: json['email'],
      name: json['name'],
    );
  }

  Shop({
    required this.userId,
    required this.name,
    required this.email
  });

  factory Shop.test() {
    return Shop(userId: 'user_id', name: 'name', email: 'abc@gmail.com');
  }

  @override
  List<Object> get props => [userId];

  @override
  Map<String, dynamic> toJson() { 
    final json = <String, dynamic>{
        'userId': userId,
        'name': name,
        'email': email,
      };
    return json;
  }
}