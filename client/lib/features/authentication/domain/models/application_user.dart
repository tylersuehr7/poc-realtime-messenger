import 'package:equatable/equatable.dart';

final class ApplicationUser extends Equatable {
  final int id;
  final String username;
  final DateTime created;
  final DateTime updated;

  const ApplicationUser({
    required this.id,
    required this.username,
    required this.created,
    required this.updated,
  });

  @override
  List<Object> get props => [
    id,
    username,
    created,
    updated,
  ];
}
