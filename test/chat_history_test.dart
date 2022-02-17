import 'package:test/test.dart';
import 'package:zoom_chat_viewer/models/models.dart';

void main() {
  test('finding participants', () {
    final history = ChatHistory.fromMessages(const <Message>[
      Message(
          sender: Participant(name: "Person 1"),
          receiver: Participant.everyone,
          content: ""),
      Message(
          sender: Participant.everyone,
          receiver: Participant(name: "Person 2"),
          content: ""),
      Message(
          sender: Participant(name: "Person 3"),
          receiver: Participant(name: "Person 4"),
          content: "")
    ]);

    expect(history.participants, <Participant>{
      Participant.everyone,
      const Participant(name: "Person 1"),
      const Participant(name: "Person 2"),
      const Participant(name: "Person 3"),
      const Participant(name: "Person 4")
    });
  });

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
    final expectedMessages = <Message>[];

    expectedMessages.add(const Message(
        sender: person1, receiver: Participant.everyone, content: "search"));

    expectedMessages.add(const Message(
        sender: person1,
        receiver: Participant.everyone,
        content: "other pages"));

    expectedMessages.add(const Message(
        sender: person2,
        receiver: Participant.everyone,
        content: "Create information hierarchy"));

    expectedMessages.add(const Message(
        sender: person2,
        receiver: Participant.everyone,
        content: "multiple pags"));

    expectedMessages.add(
        const Message(sender: person1, receiver: person2, content: "search"));

    expect(history.messages, equals(expectedMessages));
  });
}
