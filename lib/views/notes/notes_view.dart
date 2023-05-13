import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fornote/constant/route.dart';
import 'package:fornote/enums/menu_item.dart';
import 'package:fornote/extensions/build_contex/loc.dart';
import 'package:fornote/services/auth/auth_service.dart';
import 'package:fornote/services/auth/bloc/auth_bloc.dart';
import 'package:fornote/services/auth/bloc/auth_event.dart';
import 'package:fornote/services/cloud/cloud_note.dart';
import 'package:fornote/services/cloud/firebase_cloud_storag.dart';
import 'package:fornote/utilities/dialogs/logout_dialog.dart';
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
        title: Text(context.loc.notes_first_title),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, createUpdateNoteRoute);
              },
              icon: const Icon(Icons.add)),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logOut:
                  final shouldLogout = await showLogoutDialog(
                      context: context,
                      content: context.loc.logout_dialog_prompt);
                  if (shouldLogout) {
                    // ignore: use_build_context_synchronously
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
                  }
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logOut,
                  child: Text(context.loc.logout_button),
                ),
              ];
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
