global PidOutput to list(0, 0, 0).


function PitchPidUpdate
{
    parameter pitchError.
    return pitchPid:update(time:seconds, pitchError).
}


function RollPidUpdate
{
    parameter rollError.
    set PidOutput to list(rollPid:pterm, rollPid:iterm, rollPid:dterm).
    return rollPid:update(time:seconds, rollError).
}


function PitchPidInit
{
    parameter p, i, d.
    set pitchPid to pidLoop(p, i, d, -MaxTorque, MaxTorque).
    set pitchPid:setpoint to 0.
}


function RollPidInit
{
    parameter p, i, d.
    set rollPid to pidLoop(p, i, d, -MaxTorque, MaxTorque).
    set rollPid:setpoint to 0.
}
