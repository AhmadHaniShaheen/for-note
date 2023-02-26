import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fornote/constant/route.dart';
import 'package:fornote/enum/menu_item.dart';
import 'package:fornote/services/auth/firebase_auth_services.dart';
import 'package:fornote/services/crud/notes_services.dart';

class NoteView extends StatefulWidget {
  const NoteView({super.key});

  @override
  State<NoteView> createState() => _NoteViewState();
}

class _NoteViewState extends State<NoteView> {
  String get userEmail => AuthService.firebase().currentUser!.email!;
  late final NotesServices _notesServices;

  @override
  void initState() {
    super.initState();
    _notesServices = NotesServices();
  }

  @override
  void dispose() {
    _notesServices.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, newNoteRoute);
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
                  final shouldLogout = await logOutDilog(context);
                  if (shouldLogout) {
                    FirebaseAuth.instance.signOut();
                    Future.delayed(
                      const Duration(seconds: 0),
                      () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/login_screen', (_) => false);
                      },
                    );
                  }
                  break;
              }
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: _notesServices.getOrCreateUSer(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                stream: _notesServices.allNote,
                builder: (context, snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Text('wating to see notes');
                    default:
                      return const CircularProgressIndicator();
                  }
                },
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

Future<bool> logOutDilog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you wont to log out? '),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(false);
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(true);
            },
            child: const Text('Sure'),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
