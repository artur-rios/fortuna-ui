import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/features/ingestion/data/file_picker_service.dart';

/// A file as the platform picker hands it back. Only what the service reads is
/// implemented; anything else it touched would fail the test loudly.
final class _ChosenFile extends PlatformFile {
  _ChosenFile(this.name, this._bytes);

  @override
  final String name;

  final Uint8List _bytes;

  @override
  Future<Uint8List> readAsBytes() async => _bytes;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

/// Stands in for the platform picker, through the plugin's own platform
/// interface, and remembers what it was asked for.
class _FakePicker extends FilePickerPlatform {
  _FakePicker(this.answer);

  final PlatformFile? answer;
  final List<(FileType, List<String>?)> asked = [];

  @override
  Future<PlatformFile?> pickFile({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    int compressionQuality = 0,
    AndroidOptions androidOptions = const AndroidOptions(),
    DarwinOptions darwinOptions = const DarwinOptions(),
    WindowsOptions windowsOptions = const WindowsOptions(),
    LinuxOptions linuxOptions = const LinuxOptions(),
    WebOptions webOptions = const WebOptions(),
  }) async {
    asked.add((type, allowedExtensions));
    return answer;
  }
}

void main() {
  // The platform interface is process-wide, and test files share one isolate
  // when run together: replaced per test and put back after.
  late FilePickerPlatform original;

  setUp(() => original = FilePickerPlatform.instance);
  tearDown(() => FilePickerPlatform.instance = original);

  group('PlatformFilePickerService.pickFile', () {
    test('Given the user chooses a file '
        'When the picker is opened for some extensions '
        'Then it is restricted to them, and the file comes back by name and '
        'bytes rather than by path (UC-32 step 1, FR-CF-08)', () async {
      final picker = _FakePicker(
        _ChosenFile('statement.xlsx', Uint8List.fromList([1, 2, 3])),
      );
      FilePickerPlatform.instance = picker;

      final file = await const PlatformFilePickerService().pickFile(
        extensions: ['xlsx', 'pdf'],
      );

      final (type, extensions) = picker.asked.single;
      expect(type, FileType.custom);
      expect(extensions, ['xlsx', 'pdf']);
      expect(file!.name, 'statement.xlsx');
      expect(file.bytes, [1, 2, 3]);
    });

    test('Given the user closes the picker '
        'When it answers '
        'Then there is no file, and no error (UC-32 AF-03)', () async {
      FilePickerPlatform.instance = _FakePicker(null);

      final file = await const PlatformFilePickerService().pickFile(
        extensions: ['xlsx'],
      );

      expect(file, isNull);
    });
  });
}
