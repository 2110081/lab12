import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 12 Project 2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _textController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  String _fetchedText = '';

  @override
  void initState() {
    super.initState();
    _fetch();
  }

  void _fetch() async {
    final textDocument = await _firestore.collection('texts').doc('text_document').get();
    setState(() {
      _fetchedText = textDocument.data()?['text'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Project 2'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(11.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 180.0),
            const Text(
              "The text from Firestore:",
              style: TextStyle(fontSize: 22.0),
            ),
            Text(
              _fetchedText,
              style: const TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 50.0),
            TextField(
              decoration: InputDecoration(
                labelText: 'New Text',
                prefixIcon: const Icon(Icons.text_snippet),
                contentPadding: const EdgeInsets.all(19.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              controller: _textController
            ),
            const SizedBox(height: 20.0),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await _firestore.collection('texts').doc('text_document').update({
                    'text': _textController.text,
                  });
                  _fetch();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _fetch,
        child: const Icon(Icons.refresh),
      )
    );
  }
}
