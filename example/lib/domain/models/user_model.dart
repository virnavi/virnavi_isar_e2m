part of 'models.dart';

class UserModel extends Equatable {
  final String name;
  final String email;
  final int? age;

  const UserModel({required this.name, required this.email,  this.age});

  factory UserModel.empty() => UserModel(name: '', email: '');

  UserModel copyWith({
    String? name,
    String? email,
    int? age,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      age: age ?? this.age,
    );
  }

  @override
  List<Object?> get props => [name, email, age];
}
