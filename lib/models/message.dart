import 'participant.dart';

class Message {
  final Participant sender;
  final Participant receiver;
  final String content;

  const Message(
      {required this.sender, required this.receiver, required this.content});

  @override
  bool operator ==(Object other) {
    if (other is Message) {
      return sender == other.sender &&
          receiver == other.receiver &&
          content == other.content;
    }

    return false;
  }

  @override
  int get hashCode => Object.hash(sender, receiver, content);

  @override
  String toString() {
    return "Message(sender=$sender, receiver=$receiver, content=$content)";
  }
}
