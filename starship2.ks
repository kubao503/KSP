clearscreen.
run once flaps.
run once torque_to_angle.
run once pid.
run once stats.

RetractFlaps().
// Lock to normal direction
rcs on.
set sasmode to "NORMAL".
sas on.

local minQ is 0.006.
until ship:q >= minQ
{
    print "Q: " + ship:q at (0, 10).
}
clearscreen.
SAS off.
rcs off.

lock airVelocity to ship:velocity:surface.
lock pitchError to vang(airVelocity, ship:facing:forevector) - 90.

// The stronger the dynamic pressure the smaller the flap movement
lock drag to max(1, ship:q / minQ).

lock torque to PIDUpdate(pitchError).
lock flapsAngle to ClampFlapsAngle(GetAngle(torque / drag)).

until false
{
    SetFlapsAngle(flapsAngle).

    print "Pitch error: " + pitchError at (0, 13).
    print "Torque: " + torque at (0, 14).
    print "Drag: " + drag at (0, 16).

    log pitchError + ";" + torque + ";" + Period(pitchError) to ship_log.txt.

    wait 0.
}
