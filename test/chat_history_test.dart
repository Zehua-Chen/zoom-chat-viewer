import 'package:test/test.dart';
import 'package:zoom_chat_viewer/parse.dart';

void main() {
  test("parse chat history", () {
    const raw = '''16:15:14 From Person 1 to Everyone:
	search
16:15:15 From Person 1 to Everyone:
	other pages
16:15:16 From Person 2 to Everyone:
	Create information hierarchy
16:15:16 From Person 2 to Everyone:
	multiple pags
16:15:17 From Person 1 to Person 2:
	search
''';

    const person1 = Participant(name: "Person 1");
    const person2 = Participant(name: "Person 2");

    final history = ChatHistory.parse(raw);
    final expected = ChatHistory();

    expected.messages.add(const Message(
        sender: person1, receiver: Participant.everyone, content: "search"));

    expected.messages.add(const Message(
        sender: person1,
        receiver: Participant.everyone,
        content: "other pages"));

    expected.messages.add(const Message(
        sender: person2,
        receiver: Participant.everyone,
        content: "Create information hierarchy"));

    expected.messages.add(const Message(
        sender: person2,
        receiver: Participant.everyone,
        content: "multiple pags"));

    expected.messages.add(
        const Message(sender: person1, receiver: person2, content: "search"));

    expect(history.messages, equals(expected.messages));
  });
}
