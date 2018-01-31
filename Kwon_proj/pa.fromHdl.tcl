
# PlanAhead Launch Script for Pre-Synthesis Floorplanning, created by Project Navigator

create_project -name Kwon_proj -dir "C:/Kwon_proj/planAhead_run_2" -part xc3s200ft256-4
set_param project.pinAheadLayout yes
set srcset [get_property srcset [current_run -impl]]
set_property target_constrs_file "cpu_top.ucf" [current_fileset -constrset]
set hdlfile [add_files [list {binary_to_segment.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {output_logic.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {cpu.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {clock_generation.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set hdlfile [add_files [list {cpu_top.v}]]
set_property file_type Verilog $hdlfile
set_property library work $hdlfile
set_property top cpu_top $srcset
add_files [list {cpu_top.ucf}] -fileset [get_property constrset [current_run]]
open_rtl_design -part xc3s200ft256-4
