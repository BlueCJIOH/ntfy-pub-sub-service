import 'package:eventsource/eventsource.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final List<String> _messages = [];

  @override
  void initState() {
    super.initState();
    _subscribe();
  }

  Future<void> _subscribe() async {
    final server = const String.fromEnvironment('SERVER', defaultValue: 'http://localhost:8080');
    final topic = const String.fromEnvironment('TOPIC', defaultValue: 'test-topic');
    final url = '$server/$topic/sse';

    try {
      final eventSource = await EventSource.connect(url);
      eventSource.listen((event) {
        setState(() {
          _messages.add(event.data ?? '');
        });
      });
    } catch (e) {
      setState(() {
        _messages.add('Error: $e');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('ntfy subscriber')),
        body: ListView.builder(
          itemCount: _messages.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(_messages[index]),
          ),
        ),
      ),
    );
  }
}
