// Oscilation period
local raising is true.
local last_value is 0.
local last_peak_time is time:seconds.
function period
{
    parameter value.
    local difference is value - last_value.
    set last_value to value.
    if raising and difference < 0 {
        set raising to false.
        local calculated_period is time:seconds - last_peak_time.
        set last_peak_time to time:seconds.
        return calculated_period.
    } else if not raising and difference > 0 {
        set raising to true.
    }

    return "".
}

// Flaps init
// set front_flaps to SHIP:PARTSTAGGED("front_flap").
// set aft_flaps to SHIP:PARTSTAGGED("aft_flap").
// set front_flap_1 to front_flaps[0]:getmodule("ModuleControlSurface").
// set front_flap_2 to front_flaps[1]:getmodule("ModuleControlSurface").
// set aft_flap_1 to aft_flaps[0]:getmodule("ModuleControlSurface").
// set aft_flap_2 to aft_flaps[1]:getmodule("ModuleControlSurface").
//set fl_flap to SHIP:PARTSTAGGED("fl_flap")[0]:getmodule("ModuleControlSurface").
set fr_flap to SHIP:PARTSTAGGED("fr_flap")[0]:getmodule("ModuleControlSurface").
set rl_flap to SHIP:PARTSTAGGED("rl_flap")[0]:getmodule("ModuleControlSurface").
set rr_flap to SHIP:PARTSTAGGED("rr_flap")[0]:getmodule("ModuleControlSurface").

// function move_front_flaps
// {
//     parameter angle.    // Max 38 deg
//     front_flap_1:setfield("Deploy Angle", angle).
//     front_flap_2:setfield("Deploy Angle", angle).
// }

// function move_aft_flaps
// {
//     parameter angle.    // Max 38 deg
//     aft_flap_1:setfield("Deploy Angle", angle).
//     aft_flap_2:setfield("Deploy Angle", angle).
// }

// function arccos_steer
// {
//     parameter surface.

//     return -arccos(surface) + constant:pi * 0.25.
// }

function move_flaps
{
    parameter pitch.
    parameter roll.
    fl_flap:setfield("Deploy Angle", pitch - roll).
    fr_flap:setfield("Deploy Angle", pitch + roll).
    rl_flap:setfield("Deploy Angle", -pitch - roll).
    rr_flap:setfield("Deploy Angle", -pitch + roll).
    print "Pitch: " + pitch at (0, 17).
    print "Roll:  " + roll at (0, 18).
    // move_front_flaps(-pitch).
    // move_aft_flaps(pitch).
}


// Visualising vectors
function draw_arrows
{
    parameter vecotors_to_draw, clear is true.
    if clear {
        clearvecdraws().
    }
    for vector in vecotors_to_draw {
        vecdraw(v(0,0,0), vector, rgb(1,RANDOM(),0), "", 10, true, 0.02).
    }
}
