/// Saving an archive through the platform (UC-43 step 4).
///
/// Behind an interface for the usual reason — a test should not open a real
/// save dialog — but also because `AF-03` needs the refusal to be a value.
/// A save the platform declined is not a failure of the export: the archive is
/// still there, still retrievable, and the only thing that went wrong is where
/// the user pointed it.
library;

import 'package:file_saver/file_saver.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/result/result.dart';
import 'personal_export_repository.dart';

abstract interface class ArchiveSaver {
  /// Saves [archive], returning where it went.
  Future<Result<String>> save(PersonalArchive archive);
}

class PlatformArchiveSaver implements ArchiveSaver {
  const PlatformArchiveSaver();

  @override
  Future<Result<String>> save(PersonalArchive archive) async {
    try {
      final path = await FileSaver.instance.saveAs(
        name: _stem(archive.fileName),
        bytes: archive.bytes,
        fileExtension: _extension(archive.fileName),
        mimeType: MimeType.zip,
      );

      // A null path is the user closing the dialog. Not an error, and not a
      // save either — the caller offers the save again rather than claiming
      // one happened.
      if (path == null || path.isEmpty) {
        return const Failure(
          message: 'Nothing was saved.',
          kind: FailureKind.invalidInput,
        );
      }

      return Success(path);
    } on Object catch (error) {
      // AF-03: the platform refused the location. The archive is untouched.
      return Failure(
        message: 'That location could not be written to ($error).',
        kind: FailureKind.forbidden,
      );
    }
  }

  static String _stem(String fileName) {
    final dot = fileName.lastIndexOf('.');
    return dot <= 0 ? fileName : fileName.substring(0, dot);
  }

  static String _extension(String fileName) {
    final dot = fileName.lastIndexOf('.');
    return dot <= 0 || dot == fileName.length - 1
        ? 'zip'
        : fileName.substring(dot + 1);
  }
}

final archiveSaverProvider = Provider<ArchiveSaver>(
  (ref) => const PlatformArchiveSaver(),
);
