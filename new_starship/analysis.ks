clearScreen. clearVecDraws().
runOncePath("arrows.ks").
runOncePath("fuel_balancing.ks").

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

addArrow(v(0,0,0), {return ship:velocity:surface.}, 3).
addArrow(v(0,0,0), {return ship:facing:forevector.}, 10).

local lastTime is timeStamp():seconds.
local lastPitchError is 0.
local lastPitchSpeed is 0.
until false {
    local dt is max(timeStamp():seconds - lastTime, 1e-20).
    set lastTime to lastTime + dt.

    local pitchError is vang(ship:velocity:surface, ship:facing:forevector) - 90.

    local pitchSpeed is (pitchError - lastPitchError) / dt.
    set lastPitchError to pitchError.

    local pitchAcc is (pitchSpeed - lastPitchSpeed) / dt.
    set lastPitchSpeed to pitchSpeed.

    print "pitch: " + pitchError at (0, 20).
    print "speed: " + pitchSpeed at (0, 21).
    print "accel: " + pitchAcc at (0, 22).

    wait 0.01.
}
