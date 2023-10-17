clearScreen. clearVecDraws().
runOncePath("arrows.ks").
runOncePath("fuel_balancing.ks").

//lock pitchError to vang(ship:velocity:surface, ship:facing:forevector) - 90.

function roundVec {
    parameter vec, digits.
    return v(round(vec:x, digits), round(vec:y, digits), round(vec:z, digits)).
}

local function GetAeroSurface
{
    parameter partTag.
    local parts is ship:partstagged(partTag).
    return parts[0]:getmodule("ModuleAeroSurface").
}

local flapFL is GetAeroSurface("fl_flap").
local flapFR is GetAeroSurface("fr_flap").
local flapRL is GetAeroSurface("rl_flap").
local flapRR is GetAeroSurface("rr_flap").

local flapsModules is list(flapFL, flapFR, flapRL, flapRR).

until false {
    // Ship up is already normalized
    from {local i is 0.} until i = flapsModules:length step {set i to i+1.} do {
        //local totalDrag is flapsModules[i]:getField("Drag").
        print round(vdot(flapsModules[i]:part:position, ship:facing:forevector), 5) at (0, 10+i).
    }
    wait 0.
}
