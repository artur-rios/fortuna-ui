/// Choosing a file (UC-32 step 1, AF-03).
///
/// Behind an interface so tests substitute a chosen file, a cancellation or a
/// refusal without a real dialog — the platform's picker is one of the few
/// places `FR-CF-08` permits platform-specific behaviour, and one of the few a
/// test cannot drive.
library;

import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meta/meta.dart';

/// A file the user chose.
@immutable
class PickedFile {
  const PickedFile({required this.name, required this.bytes});

  final String name;
  final Uint8List bytes;
}

abstract interface class FilePickerService {
  /// Opens the picker, restricted to [extensions].
  ///
  /// Returns `null` when the user cancels — `AF-03`, which is not an error and
  /// must not be presented as one.
  Future<PickedFile?> pickFile({required List<String> extensions});
}

class PlatformFilePickerService implements FilePickerService {
  const PlatformFilePickerService();

  @override
  Future<PickedFile?> pickFile({required List<String> extensions}) async {
    final file = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: extensions,
    );

    // AF-03: a cancelled picker returns null, which is not an error.
    if (file == null) return null;

    // Read as bytes rather than by path: the web has no paths, and one code
    // path serving all four targets is the point (FR-CF-08).
    return PickedFile(name: file.name, bytes: await file.readAsBytes());
  }
}

final filePickerServiceProvider = Provider<FilePickerService>(
  (ref) => const PlatformFilePickerService(),
);
