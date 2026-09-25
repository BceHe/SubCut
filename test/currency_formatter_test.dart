import 'package:flutter_test/flutter_test.dart';

import 'package:subcut/core/utils/currency_formatter.dart';

void main() {
  test('formats IDR with thousand separators', () {
    expect(formatIdr(450000), 'Rp450.000');
    expect(formatIdr(0), 'Rp0');
  });
}