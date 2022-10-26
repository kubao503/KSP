clearscreen.

local up is ship:partstagged("up")[0]:getmodule()
//local moduleName is "ModuleAeroSurface".
//local mainBreak is ship:partstagged("main_break")[0]:getmodule(moduleName).
//local fullBreak is ship:partstagged("full_break")[0]:getmodule(moduleName).
//local halfBreak is ship:partstagged("half_break")[0]:getmodule(moduleName).
//
//local fieldName is "drag".
//lock mainDrag to mainBreak:getfield(fieldName).
//lock fullDrag to fullBreak:getfield(fieldName).
//lock halfDrag to halfBreak:getfield(fieldName).
//
//log "Angle;Main;Full;Half" to starship_log.txt.
//
//from {local angle is 0.} until angle >= 90 step {set angle to angle + 1.} do
//{
//    mainBreak:setfield("Deploy Angle", angle).
//    wait 0.2.
//    log angle + ";" + mainDrag + ";" + fullDrag + ";" + halfDrag to starship_log.txt.
//}
