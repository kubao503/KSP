clearscreen.
run once flaps.
run once torque_to_angle.
run once pid.
run once stats.

local pGain is 0.0225.
local iGain is 0.0018.
local dGain is 0.

local minQ is 0.006.
local logFile is "flight_log.txt".

list RCS in rcsList.

RCSFlight().
FlapsFlight().


function RCSFlight
{
    clearscreen.
    SetFlapsAngle(0).
    rcs on.
    for rcsThruster in rcsList
    {
        set rcsThruster:pitchenabled to true.
        set rcsThruster:yawenabled to true.
        set rcsThruster:deadband to 0.05.
    }
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
    deletepath(logFile).
    log "P gain: " + pGain + ";I gain: " + iGain + ";D gain: " + dGain to logFile.
    setPidValues(pGain, iGain, dGain).

    for rcsThruster in rcsList
    {
        set rcsThruster:pitchenabled to false.
        set rcsThruster:yawenabled to false.
        set rcsThruster:deadband to 0.004.
    }
    //SAS off.
    //rcs off.

    lock airVelocity to ship:velocity:surface.
    lock pitchError to vang(airVelocity, ship:facing:forevector) - 90.

    // The stronger the dynamic pressure the smaller the flap movement
    lock drag to max(1, GetShipDrag() * 42).

    lock torque to PIDUpdate(pitchError).
    lock flapsAngle to ClampFlapsAngle(TorqueToAngle(torque / drag)).

    until false
    {
        SetFlapsAngle(flapsAngle).

        print "Pitch error: " + pitchError at (0, 13).
        print "Torque: " + torque at (0, 14).
        print "Drag: " + drag at (0, 16).

        log pitchError + ";" + PidOutput[0] + ";" + PidOutput[1] + ";" + PidOutput[2] + ";" + Period(pitchError) to logFile.

        wait 0.
    }
}
