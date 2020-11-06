; KISSlicer - FREE
; Windows
; version 1.6.3 Release Win64
; Built: Jul  7 2018, 09:44:37
; Running on 4 cores
;
; Saved: 2020-11-05 16:25:29
; 'Cube2.gcode'
; Anti-shrink gain x=1.000000, y=1.000000, z=1.000000
; *** Printer Settings ***
; printer_name = ender
; profile_date = 2020-11-05 16:25:08
; bed_STL_filename =
; extension = gcode
; cost_per_hour = 0
; > Decoded
; >   ; [mm] mode
; >   G21
; >   ; Absolute position mode
; >   G90
; >   ; Absolute Extruder mode
; >   M82
; >   ; Start heating the Bed
; >   M140 S<BED>
; >   ; Home the axes
; >   G28
; >   ; Wait till the Bed is heated
; >   M190 S<BED>
; >   ; Heated chamber G-code is not universal
; >   ;M141 S<BOX>
; >   ;M191 S<BOX>
; g_code_preheat = NULL
; > Decoded
; > Decoded
; >   ; Head to the start of the next path
; >   G1 X<NEXTX> Y<NEXTY> F6000
; >   G4 P0
; >   ; Select the Tool (extruder)
; >   T<EXT+0>
; >   ; Correct position for multi-nozzle
; >   G1 X<NEXTX> Y<NEXTY> F6000
; >   G4 P0
; >   ; Set temp and then wait
; >   M104 S<TEMP>
; >   M109 S<TEMP>
; >   ; PURGE OR PRIME HERE IF DESIRED
; > Decoded
; >   ; Move to the start of the next path
; >   G1 X<NEXTX> Y<NEXTY> F6000
; >   G4 P0
; >   ; Same extruder, warm and wait
; >   M104 S<TEMP>
; >   M109 S<TEMP>
; > Decoded
; >   ; Same extruder, cool (no wait)
; >   G4 P0
; >   M104 S<TEMP>
; > Decoded
; >   ; Same extruder, about to deselect, maybe retract before
; >    cooling down
; >   ; RETRACT HERE IF YOU WANT
; >   G4 P0
; >   M104 S<TEMP>
; g_code_N_layers = NULL
; > Decoded
; > Decoded
; >   ; All extruders are retired
; >   ; Move the head up / bed down
; >   G91
; >   G1 Z+10
; >   G90
; >   ; turn off the bed & chamber (machine specific)
; >   M140 S0
; >   ;M141 S0
; >   ; FILL THIS IN AS NEEDED
; > Decoded
; >   ; Pause then Resume
; >   ; usually M0 (typical) or M1 (less common) or M226 (leas
; >   t portable)
; >   M0
; post_process = NULL
; > Decoded
; every_N_layers = 0
; num_extruders = 1
; bed_size_x_mm = 235
; bed_size_y_mm = 235
; bed_size_z_mm = 200
; round_bed = 0
; travel_speed_mm_per_s = 150
; first_layer_speed_mm_per_s = 20
; dmax_per_layer_mm_per_s = 15
; xy_accel_mm_per_s_per_s = 1500
; xy_steps_per_mm = 200
; top_raft_speed_mm_per_s = 20
; bottom_raft_speed_mm_per_s = 10
; ext_gain_1 = 1
; ext_1_mat_name = pla
; heat_time_coef_1 = 0.0015
; nozzle_dia_1 = 0.4
; heat_time_coef_2 = 0.0015
; *** Material Settings for Extruder 1 ***
;
; material_name = pla
; profile_date = 2020-11-05 16:25:08
; g_code_matl = NULL
; > Decoded
; g_code_matl_custom = NULL
; > Decoded
; > Decoded
; >   Material Profile Wizard
; >   > Material: PLA
; >   > Filament diameter = 1.75 [mm]
; >   > Extrusion temperature = 210 [C]
; temperature_C = 210
; keep_warm_C = 158
; first_layer_C = 210
; bed_C = 60
; chamber_C = 0
; preheat_strategy = 3
; flow_min_mm3_per_s = 0.1
; flow_max_mm3_per_s = 10
; flow_cool_mm3_per_s = 1
; destring_length = 1
; preload_factor = 0
; matl_viscosity_over_elasticity_us = 0.75
; destring_min_mm = 2.5
; destring_trigger_mm = 10
; preload_speed_mm_per_s = 25
; destring_speed_mm_per_s = 31.25
; Z_lift_mm = 0.05
; min_layer_time_s = 10
; wipe_mm = 0
; cost_per_cm3 = 0.04
; flowrate_tweak = 1
; fiber_dia_mm = 1.75

; *** Style Settings ***
;
; style_name = 20
; profile_date = 2020-11-05 16:25:08
; quality_percentage = 50
; layer_thickness_mm = -33
; max_layer_thickness_mm = -67
; first_layer_thickness_mm = -50
; unsupported_stepover_mm = -50
; supported_stepover_mm = -50
; extrusion_width_mm = 0.4
; skin_thickness_mm = 0.7
; infill_extrusion_width = 0.5
; infill_density_denominator = 4
; stacked_layers = 1
; infill_st_oct_rnd = 2
; travel_mode = 1
; inset_surface_xy_mm = 0
; seam_jitter_degrees = 0
; seam_depth_scaler = 1
; seam_gap_scaler = 0
; seam_angle_degrees = 45
; crowning_threshold_mm = 0.8
;
; *** Support Settings ***
;
; support_name = nope
; profile_date = 2020-11-05 16:25:08
; support_sheathe = 0
; support_density = 0
; use_lower_interface = 0
; solid_interface = 0
; support_inflate_mm = 0.4
; support_gap_mm = -100
; interface_gap_mm = -100
; support_angle_deg = 50
; support_z_max_mm = -1
; sheathe_z_max_mm = 2
; raft_mode = 0
; prime_pillar_mode = 4
; pillar_placement = 3
; raft_inflate_mm = 0.8
; raft_hi_stride_mm = 0.8
; raft_hi_thick_mm = 0.2
; raft_hi_width_mm = 0.4
; raft_lo_stride_mm = 1.6
; raft_lo_thick_mm = 0.4
; raft_lo_width_mm = 0.8
; brim_mm = 0
; brim_ht_mm = 0
; brim_gap_mm = 0
; brim_fillet = 0
; interface_band_mm = 0.8
; interface_Z_gap_mm = 0
; first_Z_gap_mm = 0
; raft_interface_layers = 1
; raft_interface_bond = 0
; brim_latch = 0
;
; *** Actual Slicing Settings As Used ***
;
; layer_thickness_mm = 0.132
; max_layer_thickness_mm = 0.268
; first_layer_thickness_mm = 0.2
; unsupported_stepover_mm = 0.2
; supported_stepover_mm = 0.2
; extrusion_width = 0.4
; num_ISOs = 2.5
; wall_thickness = 0.7
; infill_style = 5
; support_style = 0
; use_lower_interface = 0
; solid_interface = 0
; support_angle = 49.9
; destring_min_mm = 2.5
; stacked_infill_layers = 1
; raft_style = 0
; raft_sees_prime_paths = 0
; raft_extra_interface_layers = 0
; raft_extra_interface_bond = 0
; brim_latch = 0
; brim_mm = 0
; brim_ht_mm = -0
; brim_gap_mm = 0
; infill_st_oct_rnd = 2
; travel_mode = 1
; support_Z_max_mm = 1e+020
; support_sheathe_off_main_both_int = 0
; inset_surface_xy_mm = 0
; printer_z_step_mm = 0
; model_and_int_share_ext = 1
; Speed vs Quality = 0.50
; Top Surface Speed = 11.25
; Perimeter Speed = 15.00
; Loops Speed = 30.00
; Solid Speed = 37.50
; Sparse Speed = 45.00
;
; *** G-code Prefix ***
;
; [mm] mode
G21
; Absolute position mode
G90
; Absolute Extruder mode
M82
; Start heating the Bed
M140 S60
; Home the axes
G28
; Wait till the Bed is heated
M190 S60
; Heated chamber G-code is not universal
;M141 S0
;M191 S0
;
; *** Main G-code ***
G1 X113.9 Y123.8 Z0.32 E3.21992 F300
G1 X119.303 Y123.8 E1.01328 F1200
G1 X118.711 Y123.799 E1.05312
G1 X117.726 Y123.797 E1.11952
G1 X116.345 Y123.795 E1.21247
G1 X114.571 Y123.792 E1.33199
G1 X112.402 Y123.788 E1.47806
G1 X111.453 Y123.218 E1.55261
G1 X111.2 Y122.175 E1.62495
G1 X111.212 Y112.402 E2.28315
G1 X113.9 Y123.8 Z0.62 E3.21992 F300
; FILL THIS IN AS NEEDED
;
; Estimated Build Time:   7.66 minutes
; Estimated Build Cost:   $0.02
; Filament used per extruder:
;    Ext 1 =   238.52 mm  (0.574 cm^3)
;
; *** Extrusion Time Breakdown ***
; * estimated time in [s]
; * before possibly slowing down for 'cool'
; * not including Z-travel
;	......................................................................................
;	: Extruder #1 : Extruder #2 : Extruder #3 : Extruder #4 : Path Type                  :
;	:.............:.............:.............:.............:............................:
;	: 8.98174     : 0           : 0           : 0           : Jump Path                  :
;	: 0           : 0           : 0           : 0           : Pillar Path                :
;	: 0           : 0           : 0           : 0           : Raft Path                  :
;	: 0           > 0           > 0           > 0           > Support Interface Path     :
;	: 0           : 0           : 0           : 0           : Support (may Stack) Path   :
;	: 106.446     : 0           : 0           : 0           : Perimeter Path             :
;	: 78.0834     : 0           : 0           : 0           : Loop Path                  :
;	: 46.863      > 0           > 0           > 0           > Solid Path                 :
;	: 11.3235     : 0           : 0           : 0           : Sparse Infill Path         :
;	: 21.2211     : 0           : 0           : 0           : Stacked Sparse Infill Path :
;	: 2.78933     : 0           : 0           : 0           : Destring/Wipe/Jump Path    :
;	: 0           > 0           > 0           > 0           > Crown Path                 :
;	: 2.51037     : 0           : 0           : 0           : Prime Pillar Path          :
;	: 0           : 0           : 0           : 0           : Travel Path                :
;	: 0           : 0           : 0           : 0           : Pause Point                :
;	: 66.15       > 0           > 0           > 0           > Extruder Warm-Up           :
;	:.............:.............:.............:.............:............................:
; Total estimated (pre-cool) minutes: 5.74