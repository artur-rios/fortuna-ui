import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fortuna_ui/core/config/api_contract.dart';

void main() {
  group('ApiContract.version', () {
    test('Given the contract the client was generated from '
        'When its declared version is read '
        'Then it is the version this build claims to speak', () {
      // The drift guard. ApiContract.version cannot be read from the contract
      // at run time, so it is asserted against it here: taking a new
      // api/fortuna.json without updating the constant fails the suite rather
      // than reaching a user as a spurious AF-05.
      final contract =
          jsonDecode(File('api/fortuna.json').readAsStringSync())
              as Map<String, dynamic>;
      final declared = (contract['info'] as Map<String, dynamic>)['version'];

      expect(declared, ApiContract.version);
    });
  });

  group('ApiContract.accepts', () {
    test('Given the version this build was generated for '
        'When it is checked '
        'Then it is accepted', () {
      expect(ApiContract.accepts(ApiContract.version), isTrue);
      expect(ApiContract.accepts('  ${ApiContract.version}  '), isTrue);
    });

    test('Given a different version '
        'When it is checked '
        'Then it is refused (UC-01 AF-05)', () {
      for (final reported in ['v2', 'v0', '1', 'V1']) {
        expect(
          ApiContract.accepts(reported),
          isFalse,
          reason: '$reported should not be accepted',
        );
      }
    });

    test('Given an instance that names no version at all '
        'When it is checked '
        'Then it is refused rather than optimistically admitted (UC-01 AF-05)',
        () {
      expect(ApiContract.accepts(null), isFalse);
      expect(ApiContract.accepts(''), isFalse);
      expect(ApiContract.accepts('   '), isFalse);
    });
  });

  group('ContractCompatibility', () {
    test('Given a matching version '
        'When compatibility is asked '
        'Then it is compatible', () {
      const compatibility = ContractCompatibility(reported: 'v1');

      expect(compatibility.isCompatible, isTrue);
      expect(compatibility.expected, ApiContract.version);
    });

    test('Given an instance that named no version '
        'When it is described for the user '
        'Then it reads as having named nothing rather than as empty', () {
      const compatibility = ContractCompatibility(reported: null);

      expect(compatibility.isCompatible, isFalse);
      expect(compatibility.reportedOrUnknown, 'nothing');
    });

    test('Given an instance reporting a different version '
        'When it is described for the user '
        'Then both sides are available to name (UC-01 AF-05)', () {
      const compatibility = ContractCompatibility(reported: ' v9 ');

      expect(compatibility.reportedOrUnknown, 'v9');
      expect(compatibility.expected, 'v1');
    });
  });
}
