import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/result/result.dart';
import 'package:fortuna_ui/core/session/session_controller.dart';
import 'package:fortuna_ui/core/storage/token_store.dart';
import 'package:fortuna_ui/features/ingestion/data/file_picker_service.dart';
import 'package:fortuna_ui/features/ingestion/data/import_upload_repository.dart';
import 'package:fortuna_ui/features/ingestion/ui/import_file_screen.dart';

class _Picker implements FilePickerService {
  _Picker(this.next);

  PickedFile? Function() next;

  @override
  Future<PickedFile?> pickFile({required List<String> extensions}) async =>
      next();
}

class _Uploads implements ImportUploadRepository {
  _Uploads(this.next);

  Result<String> Function() next;

  @override
  Future<Result<String>> upload(
    PendingUpload upload, {
    String? targetId,
  }) async => next();
}

Future<void> pumpImport(
  WidgetTester tester, {
  PickedFile? Function()? picked,
  Result<String> Function()? uploadResult,
}) async {
  tester.view.physicalSize = const Size(1000, 1600);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  final container = ProviderContainer(
    overrides: [
      tokenStoreProvider.overrideWithValue(InMemoryTokenStore()),
      filePickerServiceProvider.overrideWithValue(
        _Picker(
          picked ??
              () => PickedFile(name: 'statement.xlsx', bytes: Uint8List(2048)),
        ),
      ),
      importUploadRepositoryProvider.overrideWithValue(
        _Uploads(uploadResult ?? () => const Success('job-1')),
      ),
    ],
  );
  addTearDown(container.dispose);

  await tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: const MaterialApp(home: ImportFileScreen()),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  group('ImportFileScreen', () {
    testWidgets('Given the screen '
        'When it settles '
        'Then both sources are offered with what each accepts', (tester) async {
      await pumpImport(tester);

      expect(find.text('Spreadsheet'), findsOneWidget);
      expect(find.text('Statement PDF'), findsOneWidget);
      expect(find.textContaining('Accepts .xlsx or .xls'), findsOneWidget);
      expect(find.textContaining('Accepts .pdf'), findsOneWidget);
      // The promise the whole use case rests on.
      expect(find.textContaining('uploaded exactly as it is'), findsOneWidget);
    });

    testWidgets('Given a chosen spreadsheet '
        'When it is picked '
        'Then it is offered for import', (tester) async {
      await pumpImport(tester);

      await tester.tap(find.widgetWithText(FilledButton, 'Choose file').first);
      await tester.pumpAndSettle();

      expect(find.text('statement.xlsx'), findsOneWidget);
      expect(
        find.widgetWithText(FilledButton, 'Import this file'),
        findsOneWidget,
      );
    });

    testWidgets('Given the picker is cancelled '
        'When nothing is chosen '
        'Then no error appears (UC-32 AF-03)', (tester) async {
      await pumpImport(tester, picked: () => null);

      await tester.tap(find.widgetWithText(FilledButton, 'Choose file').first);
      await tester.pumpAndSettle();

      expect(find.text('That file was not sent'), findsNothing);
      expect(find.byType(LinearProgressIndicator), findsNothing);
    });

    testWidgets('Given a file of the wrong type '
        'When it is chosen '
        'Then the refusal names what is accepted (UC-32 AF-01)', (
      tester,
    ) async {
      await pumpImport(
        tester,
        picked: () => PickedFile(name: 'notes.pdf', bytes: Uint8List(10)),
      );

      await tester.tap(find.widgetWithText(FilledButton, 'Choose file').first);
      await tester.pumpAndSettle();

      expect(find.text('That file was not sent'), findsOneWidget);
      expect(find.textContaining('.xlsx'), findsWidgets);
    });

    testWidgets('Given the upload fails '
        'When it is reported '
        'Then the same file is offered again by name (UC-32 AF-04)', (
      tester,
    ) async {
      await pumpImport(
        tester,
        uploadResult: () => const Failure(
          message: 'The upload did not complete.',
          kind: FailureKind.unreachable,
        ),
      );

      await tester.tap(find.widgetWithText(FilledButton, 'Choose file').first);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Import this file'));
      await tester.pumpAndSettle();

      expect(find.text('The import did not start'), findsOneWidget);
      expect(find.text('The upload did not complete.'), findsOneWidget);
      expect(
        find.widgetWithText(FilledButton, 'Try statement.xlsx again'),
        findsOneWidget,
      );
    });

    testWidgets('Given a successful upload '
        'When the API answers '
        'Then it says the job runs on the instance and survives leaving', (
      tester,
    ) async {
      await pumpImport(tester);

      await tester.tap(find.widgetWithText(FilledButton, 'Choose file').first);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, 'Import this file'));
      await tester.pumpAndSettle();

      expect(find.text('The import has started'), findsOneWidget);
      expect(find.textContaining('keeps going if you leave'), findsOneWidget);
    });
  });
}
