import 'package:flutter/material.dart';
import '../models/models.dart';

class FiltersForm extends StatefulWidget {
  final ChatHistory history;
  final Filters filters;

  const FiltersForm({
    Key? key,
    required this.history,
    this.filters = const Filters(
      receiver: Participant.everyone,
      sender: Participant.everyone,
    ),
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FiltersFormState();
}

class _FiltersFormState extends State<FiltersForm> {
  Participant? _sender;
  Participant? _receiver;

  bool _senderValid = true;
  bool _receiverValid = true;

  @override
  void initState() {
    super.initState();

    _sender = widget.filters.sender;
    _receiver = widget.filters.receiver;
  }

  Widget _input({
    required BuildContext context,
    required String label,
    required Participant participant,
    bool valid = true,
    required Function(Participant) onChanged,
  }) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue value) {
        if (value.text == '') {
          return [];
        }

        return widget.history.participants
            .where((p) => p.name.contains(value.text))
            .map((p) => p.name);
      },
      onSelected: (String selected) {
        onChanged(Participant(name: selected));
      },
      initialValue: TextEditingValue(text: participant.name),
      fieldViewBuilder: (context, controller, focusNode, onSubmitted) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: TextField(
            decoration: InputDecoration(
              filled: true,
              label: Text(label),
              suffixIcon: Icon(valid ? Icons.check : Icons.error),
            ),
            focusNode: focusNode,
            controller: controller,
            onSubmitted: (s) => onSubmitted(),
            onChanged: (name) {
              onChanged(Participant(name: name));
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _input(
            context: context,
            label: 'Sender',
            participant: _sender!,
            valid: _senderValid,
            onChanged: (participant) {
              setState(() {
                if (widget.history.participants.contains(participant)) {
                  _sender = participant;
                  _senderValid = true;
                } else {
                  _senderValid = false;
                }
              });
            },
          ),
          _input(
            context: context,
            label: 'Receiver',
            participant: _receiver!,
            valid: _receiverValid,
            onChanged: (participant) {
              setState(() {
                if (widget.history.participants.contains(participant)) {
                  _receiver = participant;
                  _receiverValid = true;
                } else {
                  _receiverValid = false;
                }
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: ElevatedButton(
              onPressed: () {
                if (!_senderValid || !_receiverValid) {
                  Navigator.of(context).pop(widget.filters);
                  return;
                }

                Navigator.of(context)
                    .pop(Filters(sender: _sender!, receiver: _receiver!));
              },
              child: const Text('Done'),
            ),
          ),
        ],
      ),
    );
  }
}
