class CloudStorageException implements Exception {
  const CloudStorageException();
}

class CouldNotDeleteNoteException extends CloudStorageException {}

class CouldNotUpdateNoteException extends CloudStorageException {}

class CouldNotCreateeNoteException extends CloudStorageException {}

class CouldNotGetAllNoteException implements Exception {}
