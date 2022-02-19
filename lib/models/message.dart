import 'participant.dart';
import 'error.dart';

extension on RegExp {
  bool fullyMatch(String s) {
    final match = firstMatch(s);

    if (match == null) {
      return false;
    }

    return match.start == 0 && match.end == s.length;
  }
}

class Message {
  final Participant sender;
  final Participant receiver;
  final String content;

  const Message({
    required this.sender,
    required this.receiver,
    required this.content,
  });

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

  static final messageHeader =
      RegExp(r"^[0-9]{2}:[0-9]{2}:[0-9]{2} From .+ to .+:$");

  static void _body(
    List<String> lines,
    int index,
    List<Message> messages,
    Participant sender,
    Participant receiver,
  ) {
    final buffer = StringBuffer();

    bool next() =>
        index < lines.length && !messageHeader.fullyMatch(lines[index]);

    if (next()) {
      buffer.write(lines[index]);
      index++;
    }

    while (next()) {
      final trimmed = lines[index];
      index += 1;

      if (trimmed.isEmpty && index == lines.length) {
        continue;
      }

      buffer.writeln(trimmed);
    }

    messages.add(Message(
        sender: sender, receiver: receiver, content: buffer.toString()));

    if (index < lines.length) {
      return _header(lines, index, messages);
    }
  }

  static void _header(List<String> lines, int index, List<Message> messages) {
    final line = lines[index];

    if (messageHeader.fullyMatch(line)) {
      final blocks = line.split(' ');
      final from = blocks.indexOf('From');
      final to = blocks.indexOf('to');

      final prunePattern = RegExp(r":");

      final sender =
          blocks.getRange(from + 1, to).join(' ').replaceAll(prunePattern, '');

      final receiver = blocks
          .getRange(to + 1, blocks.length)
          .join(' ')
          .replaceAll(prunePattern, '');

      return _body(lines, index + 1, messages, Participant(name: sender),
          Participant(name: receiver));
    }

    throw ChatHistorySyntaxError(
      line: line,
      lineNumber: index,
      comment: 'header expected',
    );
  }

  static List<Message> parse(String chat) {
    final lines = chat.split('\n').map((l) => l.trim()).toList();
    final messages = <Message>[];

    _header(lines, 0, messages);

    final participants = <Participant>{Participant.everyone};

    for (final message in messages) {
      participants.add(message.sender);
      participants.add(message.receiver);
    }

    return messages;
  }
}
