import 'package:flutter_test/flutter_test.dart';
import 'package:subcut/features/settings/domain/profile_validation.dart';

void main() {
  test('requires a non-blank name', () {
    expect(ProfileValidation.validateName(''), isNotNull);
    expect(ProfileValidation.validateName('   '), isNotNull);
  });

  test('accepts a name with surrounding whitespace', () {
    expect(ProfileValidation.validateName('  Budi  '), isNull);
  });
}
