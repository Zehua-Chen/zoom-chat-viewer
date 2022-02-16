enum _State { idle, print }

List<String> parse(String content) {
  final messages = <String>[];
  final lines = content.split("\n");
  var state = _State.idle;

  for (final line in lines) {
    switch (state) {
      case _State.idle:
        if (line.contains("Zehua Chen to Everyone")) {
          state = _State.print;
        }
        break;
      case _State.print:
        messages.add(line.trim());
        state = _State.idle;
        break;
    }
  }

  return messages;
}
