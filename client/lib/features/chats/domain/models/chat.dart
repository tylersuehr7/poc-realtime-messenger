import 'package:equatable/equatable.dart';

final class Chat extends Equatable {
  final String id;
  final String name;
  final int ownerId;
  final String ownerUsername;
  final DateTime created;
  final DateTime updated;

  const Chat({
    required this.id,
    required this.name,
    required this.ownerId,
    required this.ownerUsername,
    required this.created,
    required this.updated,
  });

  @override
  List<Object> get props => [
    id,
    name,
    ownerId,
    ownerUsername,
    created,
    updated,
  ];
}
