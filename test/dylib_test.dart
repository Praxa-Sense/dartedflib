import 'package:dartedflib/edflib.dart';
import 'package:test/test.dart';
import 'package:version/version.dart';

void main() {
  test('load', (){
    expect(version(), Version(1, 23, 0));
  });
}