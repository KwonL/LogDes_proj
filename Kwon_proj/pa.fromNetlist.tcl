
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name Kwon_proj -dir "C:/Kwon_proj/planAhead_run_1" -part xc3s200ft256-4
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "C:/Kwon_proj/cpu_top.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {C:/Kwon_proj} }
set_property target_constrs_file "cpu_top.ucf" [current_fileset -constrset]
add_files [list {cpu_top.ucf}] -fileset [get_property constrset [current_run]]
link_design
