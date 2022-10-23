local function GetAeroSurface
{
    parameter partTag.
    return ship:partstagged(partTag)[0]:getmodule("ModuleAeroSurface").
}


function SetFlapsAngle
{
    parameter angle.
    flapFL:setfield("Deploy Angle", defaultDeployAngle + angle).
    flapFR:setfield("Deploy Angle", defaultDeployAngle + angle).
    flapRL:setfield("Deploy Angle", defaultDeployAngle - angle).
    flapRR:setfield("Deploy Angle", defaultDeployAngle - angle).
}


function RetractFlaps
{
    flapFL:setfield("Deploy Angle", retractAngle).
    flapFR:setfield("Deploy Angle", retractAngle).
    flapRL:setfield("Deploy Angle", retractAngle).
    flapRR:setfield("Deploy Angle", retractAngle).
}


// Constants
local defaultDeployAngle is 60.
local retractAngle is 0.

local flapFL is GetAeroSurface("fl_flap").
local flapFR is GetAeroSurface("fr_flap").
local flapRL is GetAeroSurface("rl_flap").
local flapRR is GetAeroSurface("rr_flap").
