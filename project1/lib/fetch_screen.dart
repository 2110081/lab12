import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class FetchScreen extends StatefulWidget {
  const FetchScreen({super.key});

  @override
  State<FetchScreen> createState() => _FetchScreenState();
}

class _FetchScreenState extends State<FetchScreen> {
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
        title: const Text('Fetch Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(11.0),
        child: Column(
          children: <Widget>[
            const SizedBox(height: 180.0),
            const Text(
              "This is the saved text:",
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