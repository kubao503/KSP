local function GetAeroSurface
{
    parameter partTag.
    local parts is ship:partstagged(partTag).
    local modules is list().
    for part in parts
    {
        modules:add(part:getmodule("ModuleAeroSurface")).
    }
    return modules.
}


// Constants
global defaultDeployAngle is 45.
global MaxAbsAngle is min(defaultDeployAngle, 90 - defaultDeployAngle).
local retractAngle is 0.

// List of airbreaks assossiated with flaps
local flapFL is GetAeroSurface("fl_flap").
local flapFR is GetAeroSurface("fr_flap").
local flapRL is GetAeroSurface("rl_flap").
local flapRR is GetAeroSurface("rr_flap").

local minDrag is 0.0001.
lock shipDrag to flapFL[0]:getfield("drag") / max(flapFL[0]:getfield("Deploy Angle"), minDrag).


function GetShipDrag
{
    return shipDrag.
}


local function SetOneFlapAngle
{
    parameter flaps.
    parameter angle.
    for flap in flaps
    {
        flap:setfield("Deploy Angle", angle).
    }
}


function SetFlapsAngle
{
    parameter pitchTorque, rollTorque.
    SetOneFlapAngle(flapFL, defaultDeployAngle + ClampFlapsAngle(TorqueToAngle(pitchTorque - rollTorque))).
    SetOneFlapAngle(flapFR, defaultDeployAngle + ClampFlapsAngle(TorqueToAngle(pitchTorque + rollTorque))).
    SetOneFlapAngle(flapRL, defaultDeployAngle + ClampFlapsAngle(TorqueToAngle(-pitchTorque - rollTorque))).
    SetOneFlapAngle(flapRR, defaultDeployAngle + ClampFlapsAngle(TorqueToAngle(-pitchTorque + rollTorque))).
}


function RetractFlaps
{
    SetOneFlapAngle(flapFL, retractAngle).
    SetOneFlapAngle(flapFR, retractAngle).
    SetOneFlapAngle(flapRL, retractAngle).
    SetOneFlapAngle(flapRR, retractAngle).
}


function ClampFlapsAngle
{
    parameter angle.
    return max(min(angle, MaxAbsAngle), -MaxAbsAngle).
}
