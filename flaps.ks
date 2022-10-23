local function GetAeroSurface
{
    parameter partTag.
    return ship:partstagged(partTag)[0]:getmodule("ModuleAeroSurface").
}


// Constants
local maxAngle is 90.
local minAngle is 30.
local defaultDeployAngle is 60.
local retractAngle is 0.

local flapFL is GetAeroSurface("fl_flap").
local flapFR is GetAeroSurface("fr_flap").
local flapRL is GetAeroSurface("rl_flap").
local flapRR is GetAeroSurface("rr_flap").


function SetFlapsAngle
{
    parameter angle.
    local frontAngle is ClampAngle(defaultDeployAngle + angle).
    local rearAngle is ClampAngle(defaultDeployAngle - angle).
    flapFL:setfield("Deploy Angle", frontAngle).
    flapFR:setfield("Deploy Angle", frontAngle).
    flapRL:setfield("Deploy Angle", rearAngle).
    flapRR:setfield("Deploy Angle", rearAngle).
}


function RetractFlaps
{
    flapFL:setfield("Deploy Angle", retractAngle).
    flapFR:setfield("Deploy Angle", retractAngle).
    flapRL:setfield("Deploy Angle", retractAngle).
    flapRR:setfield("Deploy Angle", retractAngle).
}


// Clamps angle between minAngle and maxAngle
local function ClampAngle
{
    parameter angle.
    return min(max(angle, minAngle), maxAngle).
}
