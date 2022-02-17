import 'participant.dart';
import 'message.dart';

export 'participant.dart';
export 'message.dart';

class Filters {
  final Participant sender;
  final Participant receiver;

  const Filters({required this.sender, required this.receiver});

  bool accepts(Message message) {
    if (message.sender.name != 'Everyone') {
      if (message.sender.name != sender.name) {
        return false;
      }
    }

    if (message.receiver.name != 'Everyone') {
      if (message.receiver.name != receiver.name) {
        return false;
      }
    }

    return true;
  }
}

class ChatHistory {
  final List<Message> messages;
  final Set<Participant> participants;

  ChatHistory.empty()
      : messages = [],
        participants = {};

  ChatHistory.fromMessages(this.messages) : participants = {} {
    for (final message in messages) {
      participants.add(message.sender);
      participants.add(message.receiver);
    }
  }

  ChatHistory.parse(String content) : this.fromMessages(Message.parse(content));

  const ChatHistory({required this.messages, required this.participants});
}
