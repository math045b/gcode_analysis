//import 'package:flutter_test/flutter_test.dart';
//import 'package:gcode_analysis/gcode_analysis.dart';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;

import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  test('test', () async{
    print('test Stated');
    String gcode;
    bool tempBool;
    //print('Variables Initialized');

    gcode = await rootBundle.loadString('assets/gcode/medium_test_file.gcode');

    print('Gcode:');
    print(gcode);

    tempBool = (gcode != null) ? true : false;
    expect(tempBool, true);
  });
}
