enum _State { idle, print }

extension on RegExp {
  bool fullyMatch(String s) {
    final match = firstMatch(s);

    if (match == null) {
      return false;
    }

    return match.start == 0 && match.end == s.length;
  }
}

class ChatHistorySyntaxError extends Error {
  final String line;
  final int lineNumber;

  final String comment;

  ChatHistorySyntaxError(
      {required this.line, required this.lineNumber, required this.comment});

  @override
  String toString() {
    return 'on line $lineNumber ($line), $comment';
  }
}

class Participant {
  final String name;
  const Participant({required this.name});

  static const everyone = Participant(name: "Everyone");

  @override
  bool operator ==(Object other) {
    if (other is Participant) {
      return name == other.name;
    }

    return false;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() {
    return "Participant(name=$name)";
  }
}

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

class ChatHistory {
  List<Message> messages = [];

  static final messageHeader =
      RegExp(r"^[0-9]{2}:[0-9]{2}:[0-9]{2} From [\w, ]+ to [\w, ]+:$");

  static void _body(List<String> lines, int index, ChatHistory history,
      Participant sender, Participant receiver) {
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

    history.messages.add(Message(
        sender: sender, receiver: receiver, content: buffer.toString()));

    if (index < lines.length) {
      return _header(lines, index, history);
    }
  }

  static void _header(List<String> lines, int index, ChatHistory history) {
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

      return _body(lines, index + 1, history, Participant(name: sender),
          Participant(name: receiver));
    }

    throw ChatHistorySyntaxError(
        line: line, lineNumber: index, comment: 'header expected');
  }

  static ChatHistory parse(String chat) {
    final lines = chat.split('\n').map((l) => l.trim()).toList();
    final history = ChatHistory();

    _header(lines, 0, history);

    return history;
  }
}
