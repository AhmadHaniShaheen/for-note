import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fornote/services/cloud/cloud_note.dart';
import 'package:fornote/services/cloud/cloud_storage_constants.dart';
import 'package:fornote/services/cloud/cloud_storage_exception.dart';

class FirebaseCloudStorag {
  final notes = FirebaseFirestore.instance.collection('my_notes');
  static final FirebaseCloudStorag _shared =
      FirebaseCloudStorag._sharedInstance();
  FirebaseCloudStorag._sharedInstance();
  factory FirebaseCloudStorag() {
    return _shared;
  }
  // CRUD

  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
    final fetchNote = await document.get();
    return CloudNote(
      documentId: fetchNote.id,
      ownerUserId: ownerUserId,
      text: '',
    );
  }

  Future<Iterable<CloudNote>> getNotes({
    required String ownerUserId,
  }) async {
    try {
      return await notes
          .where(
            ownerUserIdFieldName,
            isEqualTo: ownerUserId,
          )
          .get()
          .then((value) {
        return value.docs.map((doc) {
          // return CloudNote(
          //     documentId: doc.id,
          //     ownerUserId: ownerUserId,
          //     text: doc.data()[textFieldName] as String);
          return CloudNote.fromSnapShot(doc);
        });
      });
    } catch (e) {
      throw CouldNotGetAllNoteException();
    }
  }

  Stream<Iterable<CloudNote>> getAllNote({required String ownerUserId}) =>
      notes.snapshots().map((event) => event.docs
          .map((doc) => CloudNote.fromSnapShot(doc))
          .where((note) => note.ownerUserId == ownerUserId));

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    await notes.doc(documentId).update({textFieldName: text});
  }

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (e) {
      throw CouldNotDeleteNoteException();
    }
  }
}
