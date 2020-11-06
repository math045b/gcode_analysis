library gcode_analysis;

import 'dart:ffi';
import 'dart:convert';
import 'dart:core';

import 'dart:math';

// Not Imported //
//import 'package:flutter/material.dart';
//import 'package:gcode_analysis/analyze_gcode_from_cura.dart';
//import 'dart:html';

enum Slicers { simplify3d, cura, kiri, slic3r, kisslicer, flashforge, undetermined }

class GcodeAnalysis {
  String gcode; //yes
  List<String> filteredGcode; //yes
  //Map zHeights = {};
  //List<dynamic> model = [];
  Map<String, dynamic> max;
  Map<String, dynamic> min;
  Map<String, dynamic> modelSize;

  //Map filamentByLayer = {};
  //Map filamentByExtruder = {};
  //dynamic printTimeByLayer;
  num totalFilament;
  num printTime;
  num totalWeight;
  num layerHeight;

  //dynamic layerCnt = 0;
  num layerTotal;

  //dynamic speeds = {};
  Slicers slicer = Slicers.undetermined;

  //dynamic speedsByLayer = {};
  //dynamic volSpeeds = {};
  //dynamic volSpeedsByLayer = {};
  //dynamic extrusionSpeeds = {};
  //dynamic extrusionSpeedsByLayer = {};
  Map<String, dynamic> gCodeOptions = {
    'sortLayers': false,
    'purgeEmptyLayers': true,
    'analyzeModel': false,
    'filamentType': "ABS",
    'filamentDia': 1.75,
    'nozzleDia': 0.4,
    'filamentDensity': 1.24
  };

  GcodeAnalysis();

  Future<void> analyzeGcode({String gcode}) async{
    this.gcode = gcode;
    switch(determineSlicer()) {
      case Slicers.simplify3d:
        simplify3dGetParams();
        break;
      case Slicers.cura:
        curaGetParams();
        break;
      case Slicers.kiri:
        //Todo
        break;
      case Slicers.slic3r:
        slic3rGetParams();
        break;
      case Slicers.kisslicer:
        kisslicerGetParams();
        break;
      case Slicers.flashforge:

        break;
      case Slicers.undetermined:
        break;
      default:
        break;
    }
    await findMinMax();
  }

  void setGcodeOptions(
      {bool sortLayers, bool purgeEmptyLayers, bool analyzeModel, String filamentType, Float filamentDia, Float nozzleDia, Float filamentDensity}) {
    gCodeOptions['sortLayers'] = sortLayers;
    gCodeOptions['purgeEmptyLayers'] = purgeEmptyLayers;
    gCodeOptions['analyzeModel'] = analyzeModel;
    gCodeOptions['filamentType'] = filamentType;
    gCodeOptions['filamentDia'] = filamentDia;
    gCodeOptions['nozzleDia'] = nozzleDia;
    gCodeOptions['filamentDensity'] = filamentDensity;
  }

  void filterGcode() {
    LineSplitter ls = new LineSplitter();
    filteredGcode = ls.convert(gcode);
  }

  Slicers determineSlicer() {
    final String simplify3d = 'Simplify3D(R)';
    final String cura = 'Cura_SteamEngine';
    final String kiri = 'kiri';
    final String kisslicer = 'KISSlicer';
    final String slic3r = 'Slic3r';
    final String flashforge = 'ffslicer';

    Slicers determinedSlicer;

    if (gcode.contains(kiri)) {
      determinedSlicer = Slicers.kiri;
    } else if (gcode.contains(cura)) {
      determinedSlicer = Slicers.cura;
    } else if (gcode.contains(simplify3d)) {
      determinedSlicer = Slicers.simplify3d;
    } else if (gcode.contains(slic3r)) {
      determinedSlicer = Slicers.slic3r;
    } else if (gcode.contains(kisslicer)) {
      determinedSlicer = Slicers.kisslicer;
    } else if (gcode.contains(flashforge)) {
      determinedSlicer = Slicers.flashforge;
    } else {
      determinedSlicer = Slicers.undetermined;
    }

    return determinedSlicer;
  }

  Future<void> findMinMax() async{
    bool looping = true;
    dynamic minX, minY, minZ, maxX, maxY, maxZ;
    num value;
    int currentIndex = 0;
    int otherIndex;

    while(looping){
      currentIndex = gcode.indexOf(new RegExp(r' X[0-9]| Y[0-9]| Z[0-9]'), currentIndex);
      if (currentIndex == -1){
        looping = false;
      } else{

        otherIndex = gcode.indexOf(new RegExp(r' |;|G'), currentIndex+1);

        //print('currentIndex: $currentIndex  otherIndex: $otherIndex');

        value = double.parse(gcode.substring(currentIndex+2, otherIndex));

        switch(gcode.substring(currentIndex+1, currentIndex+2)){
          case 'X':
            if(minX == null || maxX == null){
              minX = value;
              maxX = value;
            } else if(value < minX){
              minX = value;
            } else if (value > maxX){
              maxX = value;
            }
            break;
          case 'Y':
            if(minY == null || maxY == null){
              minY = value;
              maxY = value;
            } else if (value < minY) {
              minY = value;
            } else if (value > maxY) {
              maxY = value;
            }
            break;
          case 'Z':
            if(minZ == null || maxZ == null){
              minZ = value;
              maxZ = value;
            } else if (value < minZ) {
              minZ = value;
            } else if (value > maxZ) {
              maxZ = value;
            }
            break;
          default:
            break;
        }
        currentIndex++;
      }
    }

    min = {'x': minX, 'y': minY, 'z': minZ};
    max = {'x': maxX, 'y': maxY, 'z': maxZ};
    modelSize = {'x': maxX-minX, 'y': maxY-minY, 'Z': maxZ-minZ,};
  }

  void curaGetParams() {
    dynamic minX, minY, minZ, maxX, maxY, maxZ;

    List<String> str = ['MINX', 'MINY', 'MINZ', 'MAXX', 'MAXY', 'MAXZ'];

    if (gcode.contains(str[0]) &&
        gcode.contains(str[1]) &&
        gcode.contains(str[2]) &&
        gcode.contains(str[3]) &&
        gcode.contains(str[4]) &&
        gcode.contains(str[5])) {
      for (int i = 0; i < 6; i++) {
        int startIndex = gcode.indexOf(str[i]) + 5;
        double value = double.parse(gcode.substring(startIndex, gcode.indexOf(';', startIndex)));
        switch (i) {
          case 0:
            minX = value;
            break;
          case 1:
            minY = value;
            break;
          case 2:
            minZ = value;
            break;
          case 3:
            maxX = value;
            break;
          case 4:
            maxY = value;
            break;
          case 5:
            maxZ = value;
            break;
        }
      }
    }

    min = {'x': minX, 'y': minY, 'z': minZ};
    max = {'x': maxX, 'y': maxY, 'z': maxZ};

    if (gcode.contains('Layer height')) {
      int startIndex = gcode.indexOf('Layer height') + 13;
      layerHeight = double.parse(gcode.substring(startIndex, gcode.indexOf(';', startIndex)));
    }
    if (gcode.contains('TIME')) {
      int startIndex = gcode.indexOf('TIME') + 5;
      printTime = double.parse(gcode.substring(startIndex, gcode.indexOf(';', startIndex)));
    }
    if (gcode.contains('Filament used:')) {
      int startIndex = gcode.indexOf('Filament used:') + 14;
      totalFilament = double.parse(gcode.substring(startIndex, gcode.indexOf('m', startIndex))) * 1000;
    }
    if (gcode.contains('LAYER_COUNT:')) {
      int startIndex = gcode.indexOf('LAYER_COUNT:') + 12;
      layerTotal = int.parse(gcode.substring(startIndex, gcode.indexOf(';', startIndex)));
    }
  }

  void simplify3dGetParams() {
    print('test');
    if (gcode.contains('layerHeight,')) {
      int startIndex = gcode.indexOf('layerHeight,') + 12;
      layerHeight = double.parse(gcode.substring(startIndex, gcode.indexOf(';', startIndex)));
    }
    if (gcode.contains('Build time:')) {
      int startIndex = gcode.indexOf('Build time:') + 11;
      int hours = int.parse(gcode.substring(startIndex, gcode.indexOf('h', startIndex)));
      int minutes = int.parse(gcode.substring(gcode.indexOf('s', startIndex) + 1, gcode.indexOf('m', startIndex)));
      printTime = (minutes + hours * 60) * 60;
    }
    if (gcode.contains('Filament length:')) {
      int startIndex = gcode.indexOf('Filament length:') + 16;
      totalFilament = double.parse(gcode.substring(startIndex, gcode.indexOf('m', startIndex)));
    }
    if (gcode.contains('Plastic weight:')) {
      int startIndex = gcode.indexOf('Plastic weight:') + 15;
      totalWeight = double.parse(gcode.substring(startIndex, gcode.indexOf('g', startIndex)));
    }
  }

  void slic3rGetParams() {
    if (gcode.contains('layer_height =')) {
      int startIndex = gcode.indexOf('layer_height =') + 14;
      layerHeight = double.parse(gcode.substring(startIndex, gcode.indexOf(';', startIndex)));
    }
    if (gcode.contains('filament used =')) {
      int startIndex = gcode.indexOf('filament used =') + 15;
      totalFilament = double.parse(gcode.substring(startIndex, gcode.indexOf('m', startIndex)));
    }
    printTime = totalFilament/0.35;
  }

  void kisslicerGetParams() {
    if (gcode.contains('Build Time:')) {
      int startIndex = gcode.indexOf('Build Time:') + 11;
      printTime = double.parse(gcode.substring(startIndex, gcode.indexOf('m', startIndex)))*60;
    }
    if (gcode.contains('first_layer_thickness_mm =')) {
      int startIndex = gcode.indexOf('first_layer_thickness_mm =', gcode.indexOf('first_layer_thickness_mm =') + 1) + 26;
      layerHeight = double.parse(gcode.substring(startIndex, gcode.indexOf(';', startIndex)));
    }
    if (gcode.contains('Ext 1 =')) {
      int startIndex = gcode.indexOf('Ext 1 =') + 7;
      totalFilament = double.parse(gcode.substring(startIndex, gcode.indexOf('m', startIndex)));
    }
  }

  void getFilamentWeightFromLength() {
    totalWeight = (totalFilament * (gCodeOptions['filamentDia'] * gCodeOptions['filamentDia'] * pi) * gCodeOptions['filamentDensity'])/1000;
  }

  Map<String, dynamic> printAnalysis() {
    print('max: $max');
    print('min: $min');
    print('modelSize: $modelSize');
    //print('Layer Height: $layerHeight');
    print('Time: $printTime s');
    print('Filament used: $totalFilament mm');
    //print('filament weight: $totalWeight');
    //print('Layer Count: $layerTotal');

    return {'max': max, 'min': min, 'modelSize': modelSize, 'time': printTime, 'filament': totalFilament};
  }
}
