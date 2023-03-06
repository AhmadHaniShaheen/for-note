import 'package:flutter/material.dart';
import 'package:fornote/services/crud/notes_service.dart';
import 'package:fornote/utilities/dialogs/delete_dialogs.dart';

typedef NoteCallback = void Function(DatabaseNote note);

class NotesListVeiw extends StatelessWidget {
  final List<DatabaseNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;

  const NotesListVeiw({
    super.key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return ListTile(
          onTap: () {
            onTap(note);
          },
          title: Text(
            note.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
              onPressed: () async {
                final shouldDelete = await showDeleteDialog(
                    context: context,
                    content: 'Are you sure you wont to delete this item?');
                if (shouldDelete) {
                  onDeleteNote(note);
                }
              },
              icon: const Icon(Icons.delete)),
        );
      },
    );
  }
}
