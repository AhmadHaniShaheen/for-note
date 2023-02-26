import 'package:flutter/material.dart';

class NewNoteVIew extends StatefulWidget {
  const NewNoteVIew({super.key});

  @override
  State<NewNoteVIew> createState() => _NewNoteVIewState();
}

class _NewNoteVIewState extends State<NewNoteVIew> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note '),
      ),
      body: const Text('write your note here'),
    );
  }
}
