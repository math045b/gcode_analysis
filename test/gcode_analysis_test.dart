//import 'package:gcode_analysis/gcode_analysis.dart';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:gcode_analysis/gcode_analysis.dart';

final int cycles = 1;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('Speed Testing: $cycles Cycles', () {

    test('testing curaGetParams', () async{
      String gcode = await rootBundle.loadString('assets/gcode/cura_test.gcode');
      GcodeAnalysis gcodeAnalysis = new GcodeAnalysis();
      for (int i = 0; i < cycles; i++){
        await gcodeAnalysis.analyzeGcode(gcode: gcode);
      }
      Map response = gcodeAnalysis.printAnalysis();

      expect(response['time'] != null && response['filament'] != null, true);
    });
    test('testing simplify3dGetParams', () async{
      String gcode = await rootBundle.loadString('assets/gcode/simplify3d_test.gcode');
      GcodeAnalysis gcodeAnalysis = new GcodeAnalysis();
      for (int i = 0; i < cycles; i++){
        await gcodeAnalysis.analyzeGcode(gcode: gcode);
      }
      Map response = gcodeAnalysis.printAnalysis();

      expect(response['time'] != null && response['filament'] != null, true);
    });
    test('testing slic3rGetParams', () async{
      String gcode = await rootBundle.loadString('assets/gcode/slic3r.gcode');
      GcodeAnalysis gcodeAnalysis = new GcodeAnalysis();
      for (int i = 0; i < cycles; i++){
        await gcodeAnalysis.analyzeGcode(gcode: gcode);
      }
      Map response = gcodeAnalysis.printAnalysis();

      expect(response['time'] != null && response['filament'] != null, true);
    });
    test('testing kisslicer', () async{
      String gcode = await rootBundle.loadString('assets/gcode/kisslicer.gcode');
      GcodeAnalysis gcodeAnalysis = new GcodeAnalysis();
      for (int i = 0; i < cycles; i++){
        await gcodeAnalysis.analyzeGcode(gcode: gcode);
      }
      Map response = gcodeAnalysis.printAnalysis();

      expect(response['time'] != null && response['filament'] != null, true);
    });
  });

  test('Small test', () async{
    String gcode = await rootBundle.loadString('assets/gcode/cura_test.gcode');
    //String gcode = await rootBundle.loadString('assets/gcode/simplify3d_test.gcode');
    //String gcode = await rootBundle.loadString('assets/gcode/slic3r.gcode');
    //String gcode = await rootBundle.loadString('assets/gcode/kisslicer.gcode');
    //String gcode = await rootBundle.loadString('assets/gcode/small_test_file.gcode');
    GcodeAnalysis gcodeAnalysis = new GcodeAnalysis();

    gcodeAnalysis.analyzeGcode(gcode: gcode);
    Map response = gcodeAnalysis.printAnalysis();

    expect(response['time'] != null && response['filament'] != null, true);
  });
}
