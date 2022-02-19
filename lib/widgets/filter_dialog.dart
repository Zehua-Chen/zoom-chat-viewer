import 'package:flutter/material.dart';
import '../models/models.dart';

class FilterDialog extends StatefulWidget {
  final Set<Participant> participants;
  final Filters filters;

  const FilterDialog({
    Key? key,
    required this.participants,
    this.filters = const Filters(
      receiver: Participant.everyone,
      sender: Participant.everyone,
    ),
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  Participant? _sender;
  Participant? _receiver;

  @override
  void initState() {
    super.initState();

    _sender = widget.filters.sender;
    _receiver = widget.filters.receiver;
  }

  Widget _input(
    BuildContext context,
    Participant init,
    void Function(Participant) onSelected,
  ) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue value) {
        if (value.text == '') {
          return [];
        }

        return widget.participants
            .where((p) => p.name.contains(value.text))
            .map((p) => p.name);
      },
      onSelected: (String selected) {
        onSelected(Participant(name: selected));
      },
      initialValue: TextEditingValue(text: init.name),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Sender", style: Theme.of(context).textTheme.titleLarge),
            _input(context, _sender!, (participant) => _sender = participant),
            Text("Receiver", style: Theme.of(context).textTheme.titleLarge),
            _input(
                context, _receiver!, (participant) => _receiver = participant),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context)
                      .pop(Filters(sender: _sender!, receiver: _receiver!));
                },
                child: const Text('Done'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
