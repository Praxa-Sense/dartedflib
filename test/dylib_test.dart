import 'package:dartedflib/dartedflib.dart';
import 'package:test/test.dart';
import 'package:version/version.dart';

void main() {
  test('load lib and check version', () {
    expect(version(), Version(1, 23, 0));
  });
}
