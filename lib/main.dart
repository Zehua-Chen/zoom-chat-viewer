import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'package:zoom_chat_viewer/parse.dart';

void main() {
  runApp(const ZoomChatViewer());
}

class ZoomChatViewer extends StatefulWidget {
  const ZoomChatViewer({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ZoomChatViewerState();
}

class _ZoomChatViewerState extends State<ZoomChatViewer> {
  String _content = "";

  Future<void> _readFile() async {
    final result = await FilePicker.platform.pickFiles();

    if (result == null) {
      debugPrint("failed to obtain result");
      return;
    }

    if (result.files.length == 1) {
      final bytes = result.files[0].bytes;

      if (bytes == null) {
        debugPrint("failed to obtain path");
        return;
      }

      String content = utf8.decode(bytes);
      final List<String> messages = parse(content);

      setState(() {
        _content = messages.join("\n");
      });
    }
  }

  // This widget is the root of your application.
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
      home: Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: const Text("Zoom Chat Viewer"),
        ),
        body: Column(children: <Widget>[
          SingleChildScrollView(
              child: SelectableText(_content,
                  style: Theme.of(context).textTheme.bodyText1, maxLines: null))
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: _readFile,
          tooltip: 'Load File',
          child: const Icon(Icons.file_upload),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}
