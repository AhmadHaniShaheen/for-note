import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fornote/constant/route.dart';
import 'package:fornote/enums/menu_item.dart';
import 'package:fornote/services/auth/auth_service.dart';
import 'package:fornote/services/cloud/cloud_note.dart';
import 'package:fornote/services/cloud/firebase_cloud_storag.dart';
import 'package:fornote/utilities/dialogs/logout_dialogs.dart';
import 'package:fornote/views/notes/notes_list_view.dart';

class NoteView extends StatefulWidget {
  const NoteView({super.key});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  String get userId => AuthService.firebase().currentUser!.id;
  late final FirebaseCloudStorag _notesServices;

  @override
  void initState() {
    super.initState();
    _notesServices = FirebaseCloudStorag();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, createUpdateNoteRoute);
              },
              icon: const Icon(Icons.add)),
          PopupMenuButton<MenuAction>(
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logOut,
                  child: Text('Log out'),
                ),
              ];
            },
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logOut:
                  final shouldLogout = await showLogoutDialog(
                      context: context,
                      content: 'Are you sure you wont to logout?');
                  if (shouldLogout) {
                    FirebaseAuth.instance.signOut();
                    Future.delayed(
                      const Duration(seconds: 0),
                      () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, loginRoute, (_) => false);
                      },
                    );
                  }
                  break;
              }
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: _notesServices.getAllNote(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNote = snapshot.data as Iterable<CloudNote>;
                return NotesListVeiw(
                    onTap: (note) {
                      Navigator.pushNamed(
                        context,
                        createUpdateNoteRoute,
                        arguments: note,
                      );
                    },
                    notes: allNote,
                    onDeleteNote: (note) async {
                      await _notesServices.deleteNote(
                          documentId: note.documentId);
                    });
              } else {
                return const CircularProgressIndicator();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
