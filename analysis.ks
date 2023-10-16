clearScreen. clearVecDraws().
runOncePath("arrows.ks").
runOncePath("fuel_balancing.ks").

lock pitchError to vang(ship:velocity:surface, ship:facing:forevector) - 90.
until false {
    print pitchError at (0, 7).
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

local distancesToCOM is list().

for module in flapsModules {
    // Ship facing is already normalized
    distancesToCOM:add(vdot(module:part:position, ship:facing:topvector)).
}

until false {
    // Ship up is already normalized
    from {local i is 0.} until i = flapsModules:length step {set i to i+1.} do {
        local totalDrag is flapsModules[i]:getField("Drag").
        print distancesToCOM[i] + " " + totalDrag + "           " at (0, 10+i).
    }
    wait 0.
}
