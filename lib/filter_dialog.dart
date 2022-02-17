import 'package:flutter/material.dart';
import 'package:zoom_chat_viewer/parse.dart';

class Filters {
  final Participant sender;
  final Participant receiver;

  const Filters({required this.sender, required this.receiver});
}

class FilterDialog extends StatefulWidget {
  const FilterDialog({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _FilterDialogState();
}

class _FilterDialogState extends State<FilterDialog> {
  final List<Participant> _participants = const [
    Participant(name: "Peter"),
    Participant(name: "Aeter"),
    Participant(name: "Ceter"),
    Participant.everyone
  ];

  Widget _input(BuildContext context, Iterable<Participant> participants) {
    return Autocomplete<String>(optionsBuilder: (TextEditingValue value) {
      if (value.text == '') {
        return [];
      }

      return _participants
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
              _input(context, _participants),
              Text("Receiver", style: Theme.of(context).textTheme.titleLarge),
              _input(context, _participants),
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
