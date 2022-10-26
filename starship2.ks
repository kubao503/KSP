clearscreen.
run once flaps.
run once torque_to_angle.
run once pid.
run once stats.

local pGain is 0.05.
local iGain is 0.
local dGain is 0.

local minQ is 0.006.
local logName is "flight_log.txt".

RCSFlight().
FlapsFlight().


function RCSFlight
{
    clearscreen.
    RetractFlaps().
    rcs on.
    set sasmode to "NORMAL".
    sas on.

    until ship:q >= minQ
    {
        print "Q: " + ship:q at (0, 10).
        wait 0.
    }
}


function FlapsFlight
{
    clearscreen.
    log "P gain: " + pGain + ";I gain: " + iGain + ";D gain: " + dGain to logName.
    setPidValues(pGain, iGain, dGain).

    SAS off.
    rcs off.

    lock airVelocity to ship:velocity:surface.
    lock pitchError to vang(airVelocity, ship:facing:forevector) - 90.

    // The stronger the dynamic pressure the smaller the flap movement
    lock drag to max(1, ship:q / minQ).

    lock torque to PIDUpdate(pitchError).
    lock flapsAngle to ClampFlapsAngle(TorqueToAngle(torque / drag)).

    until false
    {
        SetFlapsAngle(flapsAngle).

        print "Pitch error: " + pitchError at (0, 13).
        print "Torque: " + torque at (0, 14).
        print "Drag: " + drag at (0, 16).

        log pitchError + ";" + torque + ";" + Period(pitchError) to logName.

        wait 0.
    }
}
