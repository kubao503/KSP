// PID setup
//local pGain is 2.775.
//local iGain is 1.3875.
//local dGain is 1.3875.



function PIDUpdate
{
    parameter pitchError.
    return pitchPID:update(time:seconds, pitchError).
}


function setPidValues
{
    parameter p, i, d.
    set pitchPID to pidLoop(p, i, d, -MaxTorque, MaxTorque).
    set pitchPID:setpoint to 0.
}
