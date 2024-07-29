import 'entity.dart';

class User extends Entity {
  final String userId;
  final String name;
  final String? email;

  //ignore: prefer_constructors_over_static_methods
  static User fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['_id'],
      email: json['email'],
      name: json['name'],
    );
  }

  User({
    required this.userId,
    required this.name,
    this.email,
  });

  factory User.test() {
    return User(userId: 'user_id', name: 'name');
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