// PID setup
//local pGain is 2.775.
//local iGain is 1.3875.
//local dGain is 1.3875.
local pGain is 0.1.
local iGain is 0.
local dGain is 0.

local pitchPID is pidloop(pGain, iGain, dGain, -MaxTorque, MaxTorque).
set pitchPID:setpoint to 0.

log "P gain: " + pGain + ";I gain: " + iGain + ";D gain: " + dGain to ship_log.txt.

function PIDUpdate
{
    parameter pitchError.
    return pitchPID:update(time:seconds, pitchError).
}
