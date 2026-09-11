/// Saving an export through the platform (UC-39 step 5, `FR-EX-05`).
///
/// Behind an interface for the reason `ArchiveSaver` gives — a test should not
/// open a real save dialog — and because `AF-03` needs the refusal to be a
/// value rather than an exception. A save the platform declined is not a
/// failure of the export: the file is still there and still retrievable, and
/// the only thing that went wrong is where the user pointed it.
library;

import 'package:file_saver/file_saver.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/result/result.dart';
import 'export_repository.dart';

abstract interface class ExportSaver {
  /// Saves [file], returning where it went.
  Future<Result<String>> save(ExportedFile file);
}

class PlatformExportSaver implements ExportSaver {
  const PlatformExportSaver();

  @override
  Future<Result<String>> save(ExportedFile file) async {
    try {
      final path = await FileSaver.instance.saveAs(
        name: _stem(file.fileName),
        bytes: file.bytes,
        fileExtension: _extension(file.fileName),
        mimeType: MimeType.other,
        customMimeType: file.contentType,
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
      // AF-03: the platform refused the location. The file is untouched.
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
        ? 'csv'
        : fileName.substring(dot + 1);
  }
}

final exportSaverProvider = Provider<ExportSaver>(
  (ref) => const PlatformExportSaver(),
);
