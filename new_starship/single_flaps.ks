@lazyGlobal off.

local flapFL is GetAeroSurface("fl_flap").
local flapFR is GetAeroSurface("fr_flap").
local flapRL is GetAeroSurface("rl_flap").
local flapRR is GetAeroSurface("rr_flap").

local flapsModules is list(flapFL, flapFR, flapRL, flapRR).

local maxDeployAngle is 75.

for flap in flapsModules {
    flap:setField("Deploy angle", 0).
}

function setFlapDrag {
    parameter flapIdx, targetDrag.

    local currentDrag is flapsModules[flapIdx]:getField("Drag").
    local dragDiff is targetDrag - currentDrag.

    local targetAngle is 0.
    if dragDiff > 0 {
        set targetAngle to maxDeployAngle.
    } 
    flapsModules[flapIdx]:setField("Deploy angle", targetAngle).
}

function setMaxDrag {
    parameter flapIdx.
    flapsModules[flapIdx]:setField("Deploy angle", maxDeployAngle).
}

function setMaxDragForAll {
    from {local i is 0.} until i = flapsModules:length step {set i to i+1.} do {
        setMaxDrag(i).
    }
}

function getFlapCount {
    return flapsModules:length.
}

function getFlapPosition {
    parameter idx.
    return flapsModules[idx]:part:position.
}

function getFlapDrag {
    parameter idx.
    return flapsModules[idx]:getField("Drag").
}

function getAvgDrag {
    local dragSum is 0.
    from {local i is 0.} until i = flapsModules:length step {set i to i+1.} do {
        set dragSum to dragSum + getFlapDrag(i).
    }
    return dragSum / flapsModules:length.
}

local function GetAeroSurface
{
    parameter partTag.
    local parts is ship:partstagged(partTag).
    return parts[0]:getmodule("ModuleAeroSurface").
}
