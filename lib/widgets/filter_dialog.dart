import 'package:flutter/material.dart';
import '../models/models.dart';

class FilterDialog extends StatefulWidget {
  final Set<Participant> participants;

  const FilterDialog({Key? key, required this.participants}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  Widget _input(BuildContext context) {
    return Autocomplete<String>(optionsBuilder: (TextEditingValue value) {
      if (value.text == '') {
        return [];
      }

      return widget.participants
          .where((p) => p.name.contains(value.text))
          .map((p) => p.name);
    }, onSelected: (String selected) {
      debugPrint('selected $selected');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        child: Padding(
            padding: const EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text("Sender", style: Theme.of(context).textTheme.titleLarge),
              _input(context),
              Text("Receiver", style: Theme.of(context).textTheme.titleLarge),
              _input(context),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(const Filters(
                            sender: Participant.everyone,
                            receiver: Participant.everyone));
                      },
                      child: Text('Done')))
            ])));
  }
}
