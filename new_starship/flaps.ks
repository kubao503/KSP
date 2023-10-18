@lazyGlobal off.

local flapFL is GetAeroSurface("fl_flap").
local flapFR is GetAeroSurface("fr_flap").
local flapRL is GetAeroSurface("rl_flap").
local flapRR is GetAeroSurface("rr_flap").

local flapsModules is list(flapFL, flapFR, flapRL, flapRR).

function setFlapDrag {
    parameter flapModule, targetDrag.
    local targetAngle is 0.
    if flapModule:getField("Drag") < targetDrag {
        set targetAngle to 90.
    } 
    flapModule:setField("Deploy angle", targetAngle).
}

function getFlapPosition {
    parameter idx.
    return flapsModules[idx]:part:position.
}

local function GetAeroSurface
{
    parameter partTag.
    local parts is ship:partstagged(partTag).
    return parts[0]:getmodule("ModuleAeroSurface").
}
