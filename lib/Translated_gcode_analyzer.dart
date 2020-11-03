import 'dart:ffi';

class GcodeUi {
  var reader;
  var doAnalyzeDelta = 0;
  var analyzerCallbacks;

  void fireCallback({dynamic name, dynamic payload}) {
    if (analyzerCallbacks != null && analyzerCallbacks[name] is Function) {
      analyzerCallbacks[name](payload);
    }
  }

  void processMessage(var e) {
    dynamic data = e.data;

    switch (data.cmd) {
      case "returnModel":
        fireCallback(name: "model_returned");

        // GCODE.ui.worker.postMessage({
        //   "cmd": "analyzeModel",
        //   "msg": {
        //     doAnalyzeDelta: doAnalyzeDelta > 0,
        //     deltaBedSize: doAnalyzeDelta
        //   }
        // }
        // );
        break;
      case "analyzeDone":
      //Validate data!
        bool success = false,
            isCritical = false;
        String errMsg = "";

        if (data.msg != null) {
          if (data.msg.max != null) {
            //Min-max coordinates
            if (data.msg.max.x != null && data.msg.max.y != null && data.msg.max.z != null) {
              if (data.msg.max.x is Float && data.msg.max.y is Float && data.msg.max.z is Float) {
                if (data.msg.modelSize != null) {
                  //Model size
                  if (data.msg.modelSize.x != null && data.msg.modelSize.y != null && data.msg.modelSize.z != null) {
                    if (data.msg.modelSize.x is Float && data.msg.modelSize.y is Float && data.msg.modelSize.z is Float) {
                      if (data.msg.printTime != null) {
                        //Estimated print time
                        if (data.msg.printTime is Float) {
                          if (data.msg.totalFilament != null) {
                            //Filament usage
                            if (data.msg.totalFilament is Float) {
                              success = true;

                              fireCallback(name: "analysis_done", payload: {
                                'totalFilament': data.msg.totalFilament,
                                'printTime': data.msg.printTime,
                                'printingArea': {
                                  "maxX": data.msg.max.x,
                                  "minX": data.msg.min.x,
                                  "maxY": data.msg.max.y,
                                  "minY": data.msg.min.y,
                                  "maxZ": data.msg.max.z,
                                  "minZ": data.msg.min.z,
                                },
                                'modelSize': data.msg.modelSize,
                                'deltaFits': data.msg.deltaFits,
                                'deltaError': data.msg.deltaError,
                              });
                            } else {
                              errMsg = "Filament-forbruget er ikke angivet i tal";
                            }
                          } else {
                            errMsg = "Kunne ikke udregne filament-forbruget";
                          }
                        } else {
                          errMsg = "Den estimerede print-tid er ikke angivet i tal";
                        }
                      } else {
                        errMsg = "Kunne ikke finde estimeret print-tid";
                      }
                    } else {
                      errMsg = "Modellens stÃ¸rrelse er ikke angivet i korrekte tal";
                      isCritical = true;
                    }
                  } else {
                    errMsg = "Kunne ikke fÃ¥ fat i modellens stÃ¸rrelse";
                    isCritical = true;
                  }
                } else {
                  errMsg = "Kunne ikke finde modellens sÃ¸trrelse";
                  isCritical = true;
                }
              } else {
                errMsg = "Max- & minimumspunkts-koordinaterne er ikke rigtige tal";
                isCritical = true;
              }
            } else {
              errMsg = "Kunne ikke finde max- & minimumspunkts-koordinaterne";
              isCritical = true;
            }
          } else {
            errMsg = "Kunne ikke finde max- & minimums-punkterne";
            isCritical = true;
          }
        } else {
          errMsg = "Kunne ikke finde analyse-dataen... PrÃ¸v igen";
          isCritical = true;
        }

        if (!success) {
          //GCODE analysis error
          print(success);
          print(errMsg);
          fireCallback(name: "analysis_error", payload: {'message': errMsg, 'critical': isCritical});
        }

        //GCODE.gCodeReader.processAnalyzeModelDone(data.msg);
        break;
      case "returnLayer":
        fireCallback(name: "processing_file", payload: data.msg.progress.toFixed());

        //GcodeGcodeReader.processLayerFromWorker(data.msg);
        break;
      case "returnMultiLayer":
        fireCallback(name: "processing_file", payload: data.msg.progress.toFixed());

        //GcodeGcodeReader.processMultiLayerFromWorker(data.msg);
        break;
      case "analyzeProgress":
        fireCallback(name: "analyzing_file", payload: data.msg.progress.toFixed());
        break;
      default:
        print("default msg received" + data.cmd);
    }
  }


}

class GcodeGcodeReader {
  var gcode, lines;
  Map<String, String> zHeights;
  var model = [];
  var max = {'x': null, 'y': null, 'z': null};
  var min = {'x': null, 'y': null, 'z': null};
  var modelSize = {'x': null, 'y': null, 'z': null};
  var filamentByLayer = {};
  var filamentByExtruder = {};
  var printTimeByLayer;
  var totalFilament = 0;
  var printTime = 0;
  var totalWeight = 0;
  var layerHeight = 0;
  var layerCnt = 0;
  var layerTotal = 0;
  var speeds = {};
  var slicer = 'unknown';
  var speedsByLayer = {};
  var volSpeeds = {};
  var volSpeedsByLayer = {};
  var extrusionSpeeds = {};
  var extrusionSpeedsByLayer = {};
  var gCodeOptions = {
    'sortLayers': false,
    'purgeEmptyLayers': true,
    'analyzeModel': false,
    'filamentType': "ABS",
    'filamentDia': 1.75,
    'nozzleDia': 0.4,
    'filamentDensity': 1.24
  };

  void prepareGCode() {
    if (!lines) return;
    gcode = [];
    RegExp linesRegExp = RegExp(r"^(G0|G1|G90|G91|G92|M82|M83|G28)",
      caseSensitive: true,);
    for (var i = 0; i < lines.length; i++) {
      if (linesRegExp.hasMatch(lines[i])) {
        gcode.push(lines[i]);
      }
    }
    lines = [];
    print("GCode prepared");
  }

  void sortLayers() {
    var sortedZ = [];
    var tmpModel = [];
    //var cnt = 0;
    //console.log(z_heights);
    //TODO: Fix this.. vvv
    //for (var layer in zHeights) {
    //sortedZ[zHeights[layer]] = layer;
    //cnt++;
    //}
    //        console.log("cnt is " + cnt);
    dynamic sort(dynamic a, dynamic b) {
      return a - b;
    }
    //print(sortedZ);
    //print(model.length);
    for (var i = 0; i < sortedZ.length; i++) {
      //console.log("i is " + i +" and sortedZ[i] is " + sortedZ[i] + "and z_heights[] is " + z_heights[sortedZ[i]] );
      if (zHeights[sortedZ[i]] == null) continue;
      //TODO: Fix this.. vvv
      //tmpModel[i] = model[zHeights[sortedZ[i]]];
    }
    //TODO: Fix this.. vvv
    //model = tmpModel;
    //console.log(model.length);
    //TODO: Fix this.. vvv
    //delete tmpModel;
  }

  void purgeLayers () {
    var purge = true;
    if (model == null) {
      print("Something terribly wrong just happened.");
      return;
    }
    for (var i = 0; i < model.length; i++) {
      purge = true;
      if (model[i] == null) purge = true;
      else {
        for (var j = 0; j < model[i].length; j++) {
          if (model[i][j].extrude) purge = false;
        }
      }
      if (purge) {
        model.sublist(i, 1);
        i--;
      }
    }
  }
}

class GcodeAnalyzer {}