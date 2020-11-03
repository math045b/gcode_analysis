library gcode_analysis;

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:gcode_analysis/analyze_gcode_from_cura.dart';
//import 'dart:html';

enum Slicers {simplify3d, cura, kiri, slic3r, kisslicer, skeinforge, makerbot, flashforge, undetermined}

class GcodeAnalysis {
  String gcode;
  List<String> filteredGcode;
  Map zHeights = {};
  List<dynamic> model = [];
  Map<String, dynamic> max;
  Map<String, dynamic> min;
  Map<String, dynamic> modelSize;
  Map filamentByLayer = {};
  Map filamentByExtruder = {};
  dynamic printTimeByLayer;
  dynamic totalFilament = 0;
  dynamic printTime = 0;
  dynamic totalWeight = 0;
  dynamic layerHeight = 0;
  dynamic layerCnt = 0;
  dynamic layerTotal = 0;
  dynamic speeds = {};
  Slicers slicer = Slicers.undetermined;
  dynamic speedsByLayer = {};
  dynamic volSpeeds = {};
  dynamic volSpeedsByLayer = {};
  dynamic extrusionSpeeds = {};
  dynamic extrusionSpeedsByLayer = {};
  Map<String, dynamic> gCodeOptions = {
    'sortLayers': false,
    'purgeEmptyLayers': true,
    'analyzeModel': false,
    'filamentType': "ABS",
    'filamentDia': 1.75,
    'nozzleDia': 0.4,
    'filamentDensity': 1.24
  };

  void analyzeGcode(String gcode) {
    determineSlicer(gcode);
  }

  void filterGcode(String gcode){

  }

  Slicers determineSlicer(String gcode) {
    const String simplify3d = 'Generated with Cura_SteamEngine';
    const String cura = 'Generated with Cura_SteamEngine';
    const String kiri = 'Generated with Cura_SteamEngine';

    Slicers determinedSlicer;

    if (gcode.contains(simplify3d)) determinedSlicer = Slicers.simplify3d;
    else if (gcode.contains(cura)) determinedSlicer = Slicers.cura;
    else if (gcode.contains(kiri)) determinedSlicer = Slicers.kiri;
    else determinedSlicer = Slicers.undetermined;

    return determinedSlicer;
  }


}