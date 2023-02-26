// ignore_for_file: unrelated_type_equality_checks

<<<<<<< HEAD
import 'dart:async';

=======
>>>>>>> a472854abdda48c4c89ccf97e4efde7dd1230f1b
import 'package:flutter/foundation.dart';
import 'package:fornote/services/crud/curd_exception.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class NotesServices {
<<<<<<< HEAD
  List<DatabaseNote> _notes = [];
  final _notesStreamController =
      StreamController<List<DatabaseNote>>.broadcast();

  static final NotesServices _shared = NotesServices._sharedInstace();
  NotesServices._sharedInstace();
  factory NotesServices() => _shared;

  Database? _db;

  Stream<List<DatabaseNote>> get allNote => _notesStreamController.stream;

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    // ignore: empty_catches
    } on DatabaseIsAlreadyOpenException {}
  }

  Future<DatabaseUser> getOrCreateUSer({required String email}) async {
    try {
      final user = getUser(email: email);
      return user;
    } on UserCouldNotFound {
      final createdUser = createUser(email: email);
      return createdUser;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseIsAlreadyOpenException();
=======
  Database? _db;
  Future<void> open() async {
    if (_db != null) {
      throw DatabaseIsAlreadyOpen();
>>>>>>> a472854abdda48c4c89ccf97e4efde7dd1230f1b
    }
    try {
      final dacsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(dacsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
      db.execute(createUserTable);
      db.execute(createNoteTable);
<<<<<<< HEAD
      final allNotes = await getAllNote();
      _notes = allNotes.toList();
      _notesStreamController.add(_notes);
=======
>>>>>>> a472854abdda48c4c89ccf97e4efde7dd1230f1b
    } on MissingPlatformDirectoryException {
      throw UnAbleToGetDocumentDirectory();
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
      _db = null;
    }
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  Future<void> deleteUser({required String email}) async {
<<<<<<< HEAD
    await _ensureDbIsOpen();
=======
>>>>>>> a472854abdda48c4c89ccf97e4efde7dd1230f1b
    final db = _getDatabaseOrThrow();
    final deletedCount = db
        .delete(userTable, where: 'email=? ', whereArgs: [email.toLowerCase()]);
    if (deletedCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
<<<<<<< HEAD
    await _ensureDbIsOpen();

=======
>>>>>>> a472854abdda48c4c89ccf97e4efde7dd1230f1b
    final db = _getDatabaseOrThrow();
    final results = await db.query(userTable,
        limit: 1, where: 'email=? ', whereArgs: [email.toLowerCase()]);
    if (results.isNotEmpty) {
      throw UserAlreadyExsist();
    }
    final userId = await db.insert(userTable, {
      emailColumn: email.toLowerCase(),
    });
    return DatabaseUser(id: userId, email: email);
  }

  Future<DatabaseUser> getUser({required String email}) async {
<<<<<<< HEAD
    await _ensureDbIsOpen();
=======
>>>>>>> a472854abdda48c4c89ccf97e4efde7dd1230f1b
    final db = _getDatabaseOrThrow();
    final result = await db.query(userTable,
        limit: 1, where: 'email=? ', whereArgs: [email.toLowerCase()]);
    if (result.isEmpty) {
      throw UserCouldNotFound();
    } else {
      return DatabaseUser.fromRow(result.first);
    }
  }

  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
<<<<<<< HEAD
    await _ensureDbIsOpen();

=======
>>>>>>> a472854abdda48c4c89ccf97e4efde7dd1230f1b
    final db = _getDatabaseOrThrow();
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFounUser();
    }
    const text = '';
    final noteId = await db.insert(noteTable, {
      userIdColumn: owner.id,
      textColumn: text,
      isSyncedWithCloudColumn: 1,
    });
    final note = DatabaseNote(
        id: noteId, userId: owner.id, text: text, isSyncedWithCloud: true);
<<<<<<< HEAD
    _notes.add(note);
    _notesStreamController.add(_notes);
=======
>>>>>>> a472854abdda48c4c89ccf97e4efde7dd1230f1b
    return note;
  }

  Future<void> deleteNote({required int id}) async {
<<<<<<< HEAD
    await _ensureDbIsOpen();

=======
>>>>>>> a472854abdda48c4c89ccf97e4efde7dd1230f1b
    final db = _getDatabaseOrThrow();
    final deletedCount =
        await db.delete(noteTable, where: 'id=? ', whereArgs: [id]);
    if (deletedCount == 0) {
      throw CouldNotDeleteNote();
<<<<<<< HEAD
    } else {
      _notes.removeWhere((note) => note.id == id);
      _notesStreamController.add(_notes);
=======
>>>>>>> a472854abdda48c4c89ccf97e4efde7dd1230f1b
    }
  }

  Future<int> deleteAllNote({required int id}) async {
<<<<<<< HEAD
    await _ensureDbIsOpen();

    final db = _getDatabaseOrThrow();
    final numberOfDeletion = await db.delete(noteTable);
    _notes = [];
    _notesStreamController.add(_notes);
    return numberOfDeletion;
  }

  Future<DatabaseNote> getNote({required int id}) async {
    await _ensureDbIsOpen();

=======
    final db = _getDatabaseOrThrow();
    return await db.delete(noteTable);
  }

  Future<DatabaseNote> getNote({required int id}) async {
>>>>>>> a472854abdda48c4c89ccf97e4efde7dd1230f1b
    final db = _getDatabaseOrThrow();
    final result =
        await db.query(noteTable, limit: 1, where: 'id=? ', whereArgs: [id]);
    if (result.isEmpty) {
      throw CouldNotFoundNote();
    } else {
<<<<<<< HEAD
      final note = DatabaseNote.fromRow(result.first);
      _notes.removeWhere((note) => note.id == id);
      _notesStreamController.add(_notes);
      return note;
    }
  }

  Future<Iterable<DatabaseNote>> getAllNote() async {
    await _ensureDbIsOpen();

=======
      return DatabaseNote.fromRow(result.first);
    }
  }

  Future<Iterable<DatabaseNote>> getAllNote({required int id}) async {
>>>>>>> a472854abdda48c4c89ccf97e4efde7dd1230f1b
    final db = _getDatabaseOrThrow();
    final notes = await db.query(noteTable);
    return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
  }

<<<<<<< HEAD
  Future<DatabaseNote> updatedNote(
      {required String text, required DatabaseNote note}) async {
    await _ensureDbIsOpen();

=======
  Future<DatabaseNote> update(
      {required String text, required DatabaseNote note}) async {
>>>>>>> a472854abdda48c4c89ccf97e4efde7dd1230f1b
    final db = _getDatabaseOrThrow();
    final updateCount = await db.update(noteTable, {
      textColumn: text,
      isSyncedWithCloudColumn: 0,
    });
    if (updateCount == 0) {
      throw CouldNotUpdateNote();
    } else {
<<<<<<< HEAD
      final updatedNote = await getNote(id: note.id);
      _notes.removeWhere((note) => note.id == updatedNote.id);
      _notesStreamController.add(_notes);
      return updatedNote;
=======
      return await getNote(id: note.id);
>>>>>>> a472854abdda48c4c89ccf97e4efde7dd1230f1b
    }
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({
    required this.id,
    required this.email,
  });

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => 'Person ,ID=$id ,email=$email';
  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  DatabaseNote({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedWithCloud,
  });

  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String,
        isSyncedWithCloud =
            (map[isSyncedWithCloudColumn] as int) == 1 ? true : false;

  @override
  String toString() =>
      'Note, id =$id ,userId=$userId , text=$text, isSyncedWithCloud=$isSyncedWithCloud';

  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const idColumn = 'id';
const emailColumn = 'email';
const textColumn = '';
const userIdColumn = 'user_id';
const isSyncedWithCloudColumn = "is_synced_with_cloud";
const dbName = 'notes.db';

const createUserTable = '''CREATE TABLE "user" (
	"id"	INTEGER NOT NULL,
	"email"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("id" AUTOINCREMENT)
);
''';

const createNoteTable = '''CREATE TABLE "note" (
	"id"	INTEGER NOT NULL,
	"user_id"	INTEGER NOT NULL,
	"text"	TEXT NOT NULL,
	"is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
	PRIMARY KEY("id" AUTOINCREMENT)
);
''';
const userTable = 'user';
const noteTable = 'note';
