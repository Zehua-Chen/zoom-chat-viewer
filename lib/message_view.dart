import 'package:flutter/material.dart';
import 'package:zoom_chat_viewer/parse.dart';

class MessageView extends StatelessWidget {
  final Message message;

  const MessageView({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(
                  '${message.sender.name} to ${message.receiver.name}',
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
              SelectableText(message.content,
                  style: Theme.of(context).textTheme.bodyMedium)
            ]));
  }
}
