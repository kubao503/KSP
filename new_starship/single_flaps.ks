@lazyGlobal off.

local flapFL is GetAeroSurface("fl_flap").
local flapFR is GetAeroSurface("fr_flap").
local flapRL is GetAeroSurface("rl_flap").
local flapRR is GetAeroSurface("rr_flap").

local flapsModules is list(flapFL, flapFR, flapRL, flapRR).

local maxDeployAngle is 90.

for flap in flapsModules {
    flap:setField("Deploy angle", 0).
}

function setFlapDrag {
    parameter flapIdx, targetDrag.
    local targetAngle is 0.
    if flapsModules[flapIdx]:getField("Drag") < targetDrag {
        set targetAngle to maxDeployAngle.
    } 
    flapsModules[flapIdx]:setField("Deploy angle", targetAngle).
}

function setMaxDrag {
    parameter flapIdx.
    flapsModules[flapIdx]:setField("Deploy angle", maxDeployAngle).
}

function getFlapPosition {
    parameter idx.
    return flapsModules[idx]:part:position.
}

function getFlapDrag {
    parameter idx.
    return flapsModules[idx]:getField("Drag").
}

local function GetAeroSurface
{
    parameter partTag.
    local parts is ship:partstagged(partTag).
    return parts[0]:getmodule("ModuleAeroSurface").
}
