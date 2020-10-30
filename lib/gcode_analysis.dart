library gcode_analysis;

import 'dart:ffi';
//import 'dart:html';

class GcodeUi {
  var reader;
  var doAnalyzeDelta = 0;
  var analyzerCallbacks;

  fireCallback({dynamic name, dynamic payload}) {
    if (analyzerCallbacks != null && analyzerCallbacks[name] is Function) {
      analyzerCallbacks[name](payload);
    }
  }

  processMessage(var e) {
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
        bool success = false, isCritical = false;
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

class GcodeGcodeReader {}

class GcodeAnalyzer {}
