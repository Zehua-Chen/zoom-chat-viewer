import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'models/models.dart';
import 'widgets/message_view.dart';
import 'widgets/filter_dialog.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zoom Chat Viewer',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const AppHome(),
    );
  }
}

class AppHome extends StatefulWidget {
  const AppHome({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  List<String> _messages = [];
  ChatHistory? _history;

  Future<void> _readFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result == null) {
      debugPrint('failed to obtain result');
      return;
    }

    if (result.files.length == 1) {
      final bytes = result.files[0].bytes;

      if (bytes == null) {
        debugPrint('failed to obtain path');
        return;
      }

      String content = utf8.decode(bytes);
      final history = ChatHistory.parse(content);

      setState(() {
        _history = history;

        _messages = history.messages
            .where((m) =>
                m.sender.name == 'Zehua Chen' && m.receiver.name == 'Everyone')
            .map((m) => m.content)
            .toList();
      });
    }
  }

  void _onCopy() {
    Clipboard.setData(ClipboardData(text: _messages.join('\n')));
  }

  void _showFilter(BuildContext context) async {
    final filters =
        await showDialog<Filters>(context: context, builder: _filterDialog);

    if (filters == null) {
      return;
    }

    debugPrint(filters.sender.name);
    debugPrint(filters.receiver.name);
  }

  Widget _filterDialog(BuildContext context) {
    return const FilterDialog();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Zoom Chat Viewer'),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.filter_list),
              onPressed: () {
                _showFilter(context);
              }),
          IconButton(
              icon: const Icon(Icons.copy),
              tooltip: 'Copy to Clipboard',
              onPressed: _onCopy)
        ],
      ),
      body: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: _history?.messages.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            final Message message = _history!.messages[index];
            return MessageView(message: message);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: _readFile,
        tooltip: 'Load File',
        child: const Icon(Icons.file_upload),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
