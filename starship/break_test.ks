clearscreen.
run once flaps.
run once torque_to_angle.
SetFlapsAngle(0, 0).
//
//local moduleName is "ModuleAeroSurface".
//local mainBreak is ship:partstagged("main_break")[0]:getmodule(moduleName).
//local fullBreak is ship:partstagged("full_break")[0]:getmodule(moduleName).
//local halfBreak is ship:partstagged("half_break")[0]:getmodule(moduleName).
//
//local fieldName is "drag".
//lock mainDrag to mainBreak:getfield(fieldName).
//lock fullDrag to fullBreak:getfield(fieldName).
//lock halfDrag to halfBreak:getfield(fieldName).

//log "Angle;Main;Full;Half" to starship_log.txt.

//from {local angle is 0.} until angle >= 90 step {set angle to angle + 1.} do
//{
//    mainBreak:setfield("Deploy Angle", angle).
//    wait 0.2.
//    log angle + ";" + mainDrag + ";" + fullDrag + ";" + halfDrag to starship_log.txt.
//}
//list rcs in rcsList.
//rcs on.
//for rcsThruster in rcsList
//{
    //set rcsThruster:pitchenabled to true.
    //set rcsThruster:yawenabled to true.
    //set rcsThruster:deadband to 0.004.
//}
//lock steering to lookDirUp(ship:facing:vector, ship:up:vector).
//lock atmP to 2.718^((0-altitude)/5000).
//local log_name is "test_log.txt".
//deletepath(log_name).
//log "mainDrag;halfDrag;fullDrag;altitude;ship:airspeed;ship:q" to log_name.
//until false
//{
    ////log mainDrag + ";" + halfDrag + ";" + fullDrag + ";" + altitude + ";" + ship:airspeed + ";" + ship:q to log_name.
    //wait 0.
//}
//
