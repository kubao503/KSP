clearscreen.
run once flaps.
run once torque_to_angle.
run once pid.
run once stats.

local pitch_pGain is 0.100.
local pitch_iGain is 0.002.
local pitch_dGain is 0.1125.

local roll_pGain is 0.08.
local roll_iGain is 0.
local roll_dGain is 0.

local minQ is 0.003.
local logFile is "roll_log.txt".

list RCS in rcsList.

RCSFlight().
FlapsFlight().


function RCSFlight
{
    clearscreen.
    lock pitchTorque to 0.
    lock rollTorque to 0.
    SetFlapsAngle(pitchTorque, rollTorque).
    rcs on.
    for rcsThruster in rcsList
    {
        set rcsThruster:pitchenabled to true.
        set rcsThruster:yawenabled to true.
        set rcsThruster:deadband to 0.004.
    }
    sas on.
    wait 0.
    set sasmode to "NORMAL".

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
    log "P gain: " + roll_pGain + ";I gain: " + roll_iGain + ";D gain: " + roll_dGain to logFile.
    PitchPidInit(pitch_pGain, pitch_iGain, pitch_dGain).
    RollPidInit(roll_pGain, roll_iGain, roll_dGain).

    sas off.
    rcs off.
    //set SteeringManager:TORQUEEPSILONmin to 0.00001.
    //set SteeringManager:TORQUEEPSILONmax to 0.00001.
    //for rcsThruster in rcsList
    //{
    //    set rcsThruster:pitchenabled to false.
    //    set rcsThruster:yawenabled to false.
    //    set rcsThruster:deadband to 0.001.
    //}
    //lock steering to lookDirUp(ship:facing:vector, ship:up:vector).

    lock airVelocity to ship:velocity:surface.
    lock pitchError to vang(airVelocity, ship:facing:forevector) - 90.
    lock rollError to vang(airVelocity, ship:facing:starvector) - 90.

    // The stronger the dynamic pressure the smaller the flap movement
    lock drag to max(1, GetShipDrag() * 42).

    lock pitchTorque to PitchPidUpdate(pitchError) / drag.
    lock rollTorque to RollPidUpdate(rollError) / drag.
    //lock flapsAngle to ClampFlapsAngle(TorqueToAngle(pitchTorque / drag)).

    until false
    {
        SetFlapsAngle(pitchTorque, rollTorque).

        print "Pitch error: " + pitchError at (0, 13).
        print "Roll error: " + rollError at (0, 16).

        log rollError + ";" + PidOutput[0] + ";" + PidOutput[1] + ";" + PidOutput[2] + ";" + Period(rollError) to logFile.

        wait 0.
    }
}
