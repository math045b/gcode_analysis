//import 'package:flutter_test/flutter_test.dart';
//import 'package:gcode_analysis/gcode_analysis.dart';

import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Testing RegExp', () {
    test('RegExp Test 1', () {
      String testStr = 'G90 blablabla';

      RegExp linesRegExp = RegExp(r"^(G0|G1|G90|G91|G92|M82|M83|G28)",
        caseSensitive: true,);

      expect(linesRegExp.hasMatch(testStr), true);
    });
    test('RegExp Test 2', () {
      String testStr = 'g90 blablabla';

      RegExp linesRegExp = RegExp(r"^(G0|G1|G90|G91|G92|M82|M83|G28)",
        caseSensitive: true,);

      expect(linesRegExp.hasMatch(testStr), false);
    });
  });
}
