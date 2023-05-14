import 'package:flutter/material.dart';
import 'package:fornote/constant/route.dart';
import 'package:fornote/services/auth/auth_service.dart';
import 'package:fornote/services/cloud/cloud_note.dart';
import 'package:fornote/services/cloud/firebase_cloud_storag.dart';
import 'package:fornote/utilities/dialogs/cannot_share_empty_note_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import 'package:fornote/extensions/build_contex/loc.dart';
import 'package:fornote/utilities/generics/get_argument.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  State<CreateUpdateNoteView> createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  CloudNote? _note;
  late final FirebaseCloudStorag _notesServices;
  late final TextEditingController _textController;

  @override
  void initState() {
    _notesServices = FirebaseCloudStorag();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _notesServices.updateNote(documentId: note.documentId, text: text);
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<CloudNote> createIrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<CloudNote>();
    if (widgetNote != null) {
      _note = widgetNote;
      _textController.text = widgetNote.text;
      return widgetNote;
    }
    final exisitingNote = _note;
    if (exisitingNote != null) {
      return exisitingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final ownerUserId = currentUser.id;
    final newNote =
        await _notesServices.createNewNote(ownerUserId: ownerUserId);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() async {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _notesServices.deleteNote(documentId: note.documentId);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (note != null && text.isNotEmpty) {
      _notesServices.updateNote(documentId: note.documentId, text: text);
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
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, noteRoute);
          },
          icon: const Icon(Icons.arrow_back_ios),
          color: const Color(0xff9098B1),
        ),
        toolbarHeight: 70.0,
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          context.loc.new_note,
          style: GoogleFonts.urbanist(
              color: const Color(0xff1C2760),
              fontSize: 24,
              fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: IconButton(
              onPressed: () async {
                final text = _textController.text;
                if (_note == null || text.isEmpty) {
                  await cannotShareEmptyNoteDialog(context: context);
                } else {
                  Share.share(text);
                }
              },
              icon: const Icon(
                Icons.share,
              ),
              color: const Color(0xff9098B1),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: createIrGetExistingNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setupTextControllerListener();
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  textCapitalization: TextCapitalization.sentences,
                  controller: _textController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: context.loc.new_note_placeholder,
                    focusColor: Colors.red,
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xff09C2B5)),
                    ),
                  ),
                ),
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
