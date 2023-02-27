import 'package:flutter/material.dart';
import 'package:fornote/services/auth/firebase_auth_services.dart';

import '../../services/crud/notes_services.dart';

class NewNoteVIew extends StatefulWidget {
  const NewNoteVIew({super.key});

  @override
  State<NewNoteVIew> createState() => _NewNoteVIewState();
}

class _NewNoteVIewState extends State<NewNoteVIew> {
  DatabaseNote? _note;
  late final NotesServices _notesServices;
  late final TextEditingController _textController;

  @override
  void initState() {
    _textController = TextEditingController();
    _notesServices = NotesServices();
    super.initState();
  }

  Future<DatabaseNote> createNote() async {
    final exisitingNote = _note;
    if (exisitingNote != null) {
      return exisitingNote;
    }
    final email = AuthService.firebase().currentUser!.email!;
    final owner = await _notesServices.getUser(email: email);
    return await _notesServices.createNote(owner: owner);
  }

  void _deleteNoteIfTextIsEmpty() async {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _notesServices.deleteNote(id: note.id);
    }
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _notesServices.updatedNote(text: text, note: note);
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (note != null && text.isNotEmpty) {
      _notesServices.updatedNote(text: text, note: note);
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note '),
      ),
      body: FutureBuilder(
        future: createNote(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _note = snapshot.data as DatabaseNote;
              _setupTextControllerListener();
              return TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                decoration:
                    const InputDecoration(hintText: 'start typing your note'),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
