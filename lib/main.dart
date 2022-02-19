import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'models/models.dart';
import 'widgets/message_view.dart';
import 'widgets/filters_form.dart';

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
        // errorColor: Colors.red,
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
  ChatHistory? _history;
  Filters _filters = const Filters(
    sender: Participant.everyone,
    receiver: Participant.everyone,
  );

  List<Message>? get _messages {
    return _history?.messages
        .where((message) => _filters.accepts(message))
        .toList();
  }

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
      });
    }
  }

  void _onCopy() {
    Clipboard.setData(
        ClipboardData(text: _messages?.map((m) => m.content).join('\n')));
  }

  void _showFilter(BuildContext context) async {
    final filters =
        await showDialog<Filters>(context: context, builder: _filterDialog);

    if (filters == null) {
      return;
    }

    setState(() {
      _filters = filters;
    });
  }

  Widget _filterDialog(BuildContext context) {
    if (_history == null) {
      return const Dialog(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Must load a chat log first!'),
        ),
      );
    }

    return Dialog(
      child: FiltersForm(history: _history!, filters: _filters),
    );
  }

  double _horizontalPadding(BuildContext context) {
    final query = MediaQuery.of(context);
    final width = query.size.width;

    if (width < 1024) {
      return 32;
    }

    return 64;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final messages = _messages;

    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text('Zoom Chat Viewer'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Edit filters',
            onPressed: () {
              _showFilter(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.copy),
            tooltip: 'Copy to Clipboard',
            onPressed: _onCopy,
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: _horizontalPadding(context)),
        itemCount: messages?.length ?? 0,
        itemBuilder: (BuildContext context, int index) {
          final Message message = messages![index];
          return MessageView(message: message);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _readFile,
        tooltip: 'Load File',
        child: const Icon(Icons.file_upload),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
