import 'package:flutter/material.dart';
import '../models/models.dart';

extension on Participant {
  String get initials {
    return name.split(' ').where((e) => e.isNotEmpty).map((e) => e[0]).join('');
  }
}

class MessageView extends StatelessWidget {
  final Message message;

  const MessageView({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        children: [
          Tooltip(
            message: message.sender.name,
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: CircleAvatar(
                child: Text(message.sender.initials),
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(
                'To ${message.receiver.name}',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              SelectableText(
                message.content,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
