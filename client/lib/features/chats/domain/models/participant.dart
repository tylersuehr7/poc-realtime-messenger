import 'package:equatable/equatable.dart';

final class Participant extends Equatable {
  final String id;
  final int accountId;
  final String accountUsername;
  final String chatId;
  final String chatName;
  final DateTime created;
  final DateTime updated;

  const Participant({
    required this.id,
    required this.accountId,
    required this.accountUsername,
    required this.chatId,
    required this.chatName,
    required this.created,
    required this.updated,
  });

  @override
  List<Object> get props => [
    id,
    accountId,
    accountUsername,
    chatId,
    chatName,
    created,
    updated,
  ];
}
