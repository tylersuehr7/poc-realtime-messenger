import 'package:equatable/equatable.dart';

final class Message extends Equatable {
  final String id;
  final int authorId;
  final String authorUsername;
  final String content;
  final DateTime created;
  final DateTime updated;
  final DateTime? sentOn;
  final DateTime? deliveredOn;

  const Message({
    required this.id,
    required this.authorId,
    required this.authorUsername,
    required this.content,
    required this.created,
    required this.updated,
    this.sentOn,
    this.deliveredOn,
  });

  @override
  List<Object?> get props => [
    id,
    authorId,
    authorUsername,
    content,
    created,
    updated,
    sentOn,
    deliveredOn,
  ];
}
