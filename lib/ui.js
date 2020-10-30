/**
 * User: hudbrog (hudbrog@gmail.com)
 * Date: 10/21/12
 * Time: 7:45 AM
 *
 * Modified by Albert MN. - SimplyPrint 23/09/2020
 */

var GCODE = {};

GCODE.ui = (function () {
    var reader;
    let doAnalyzeDelta = 0,
        analyzerCallbacks = null;

    var FireCallback = function (name, payload = null) {
        if (analyzerCallbacks !== null && typeof analyzerCallbacks[name] === "function") {
            analyzerCallbacks[name](payload);
        }
    };

    var processMessage = function (e) {
        let data = e.data;

        switch (data.cmd) {
            case "returnModel":
                FireCallback("model_returned");

                GCODE.ui.worker.postMessage({
                        "cmd": "analyzeModel",
                        "msg": {
                            doAnalyzeDelta: doAnalyzeDelta > 0,
                            deltaBedSize: doAnalyzeDelta
                        }
                    }
                );
                break;
            case "analyzeDone":
                //Validate data!
                let success = false, errMsg = "", isCritical = false;

                if (typeof data.msg !== "undefined") {
                    if (typeof data.msg.max !== "undefined") {
                        //Min-max coordinates
                        if (typeof data.msg.max.x !== "undefined" && typeof data.msg.max.y !== "undefined" && typeof data.msg.max.z !== "undefined") {
                            if (Number(data.msg.max.x) && Number(data.msg.max.y) && Number(data.msg.max.z)) {
                                if (typeof data.msg.modelSize !== "undefined") {
                                    //Model size
                                    if (typeof data.msg.modelSize.x !== "undefined" && typeof data.msg.modelSize.y !== "undefined" && typeof data.msg.modelSize.z !== "undefined") {
                                        if (!isNaN(Number(data.msg.modelSize.x)) && !isNaN(Number(data.msg.modelSize.y)) && !isNaN(Number(data.msg.modelSize.z))) {
                                            if (typeof data.msg.printTime !== "undefined") {
                                                //Estimated print time
                                                if (!isNaN(Number(data.msg.printTime))) {
                                                    if (typeof data.msg.totalFilament) {
                                                        //Filament usage
                                                        if (!isNaN(Number(data.msg.totalFilament))) {
                                                            success = true;

                                                            FireCallback("analysis_done", {
                                                                totalFilament: data.msg.totalFilament,
                                                                printTime: data.msg.printTime,
                                                                printingArea: {
                                                                    "maxX": data.msg.max.x,
                                                                    "minX": data.msg.min.x,

                                                                    "maxY": data.msg.max.y,
                                                                    "minY": data.msg.min.y,

                                                                    "maxZ": data.msg.max.z,
                                                                    "minZ": data.msg.min.z
                                                                },
                                                                modelSize: data.msg.modelSize,
                                                                deltaFits: data.msg.deltaFits,
                                                                deltaError: data.msg.deltaError,
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
                    console.log(success);
                    console.log(errMsg);
                    FireCallback("analysis_error", {message: errMsg, critical: isCritical});
                }

                //GCODE.gCodeReader.processAnalyzeModelDone(data.msg);
                break;
            case "returnLayer":
                FireCallback("processing_file", data.msg.progress.toFixed());

                GCODE.gCodeReader.processLayerFromWorker(data.msg);
                break;
            case "returnMultiLayer":
                FireCallback("processing_file", data.msg.progress.toFixed());

                GCODE.gCodeReader.processMultiLayerFromWorker(data.msg);
                break;
            case "analyzeProgress":
                FireCallback("analyzing_file", typeof data.msg.progress === "number" ? data.msg.progress.toFixed() : null);
                break;
            default:
                console.log("default msg received" + data.cmd);
        }
    };

    var checkCapabilities = function () {
        let fatal = [];

        Modernizr.addTest("filereader", function () {
            return !!(window.File && window.FileList && window.FileReader);
        });

        if (!Modernizr.canvas) fatal.push("<li>Your browser doesn't seem to support HTML5 Canvas, this application won't work without it.</li>");
        if (!Modernizr.filereader) fatal.push("<li>Your browser doesn't seem to support HTML5 File API, this application won't work without it.</li>");
        if (!Modernizr.webworkers) fatal.push("<li>Your browser doesn't seem to support HTML5 Web Workers, this application won't work without it.</li>");
        if (!Modernizr.svg) fatal.push("<li>Your browser doesn't seem to support HTML5 SVG, this application won't work without it.</li>");

        if (fatal.length > 0) {
            document.getElementById('errorList').innerHTML = '<ul>' + fatal.join('') + '</ul>';
            console.log("Initialization failed: unsupported browser.");
            return false;
        }

        return true;
    };

    return {
        worker: undefined,
        initHandlers: function () {
            if (!checkCapabilities()) {
                return;
            }

            this.worker = new Worker(rootUrl + "assets/js/hub/gcode_analysis/Worker.js?v=14");
            this.worker.addEventListener("message", processMessage, false);
        },

        //New handler
        AnalyzeGcode: function (printerInfo, callbacks, file, fromUrl = false, kiriSliced = false) {
            FireCallback("file_prepare");
            analyzerCallbacks = callbacks;

            function FileHandling(theFile) {
                //File selected
                FireCallback("process_begin");
                GCODE.gCodeReader.loadFile(theFile, kiriSliced);
            }

            GCODE.gCodeReader.setOption({
                sortLayers: true,
                purgeEmptyLayers: true,
                volumetricE: false,
                filamentDia: printerInfo.filamentDia,
                nozzleDia: printerInfo.nozzleDia,
                filamentType: printerInfo.filamentType,
                filamentDensity: printerInfo.filamentDensity
            });

            doAnalyzeDelta = printerInfo.analyzeDelta;

            if (fromUrl) {
                //Analyze a GCODE file at an URL
                let blob = null,
                    xhr = new XMLHttpRequest();

                xhr.open("GET", file);
                xhr.responseType = "blob"; //force the HTTP response, response-type header to be blob
                xhr.onload = function () {
                    blob = xhr.response;

                    reader = new FileReader();
                    reader.onload = function (theFile) {
                        FileHandling(theFile.target.result);
                    };
                    reader.readAsText(blob);
                };
                xhr.send();
            } else {
                //Has Blob or even text
                if (file instanceof Blob) {
                    reader = new FileReader();
                    reader.onload = function (theFile) {
                        FileHandling(theFile.target.result);
                    };
                    reader.readAsText(file);
                } else if (typeof file === "string") {
                    FileHandling(file);
                } else {
                    FireCallback("pre_process_fail", "File is not text or Blob");
                }
            }
        },
    }
}());