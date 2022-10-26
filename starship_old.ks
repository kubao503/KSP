clearscreen.
clearvecdraws().
run once starship_func.

// Vector calculations
lock plane_vector to ship:velocity:surface.
// lock flat_vector to vectorExclude(plane_vector, ship:facing:forevector).
// lock sign to choose 1 if vang(plane_vector, ship:facing:forevector) < 90 else -1.
// lock pitch_error to vang(flat_vector, ship:facing:forevector) * sign.
lock pitch_error to vang(plane_vector, ship:facing:forevector) - 90.
// lock flat_vector to vectorExclude(plane_vector, ship:facing:starvector).
lock roll_error to vang(plane_vector, ship:facing:starvector) - 90.

// Arrows setup
draw_arrows(list(
    {return plane_vector.}
)).



set rotation_d_gain to 3.
set SteeringManager:yawpid:kd to rotation_d_gain.
set SteeringManager:pitchpid:kd to rotation_d_gain.
set SteeringManager:rollpid:kd to rotation_d_gain.

// Log init
deletepath(ship_log.txt).
create(ship_log.txt).
log "P gain: " + p_gain to ship_log.txt.
log "I gain: " + i_gain to ship_log.txt.
log "D gain: " + d_gain to ship_log.txt.

// Test init
local min_altitude is 1000.
local max_altitude is 55000.
local drag_threshold is 3000.

// RCS control
print "RCS control" at (0, 0).
rcs on.
lock nose_up to vectorexclude(plane_vector, up:forevector).
lock steering to nose_up.
lock air_drag to ship:q * ship:airspeed^2.


until air_drag > drag_threshold or ship:altitude < max_altitude
{
    // draw_arrows(list(nose_up)).
    print air_drag at (0, 3).
    wait 0.
}
rcs off.
unlock nose_up.
unlock steering.
unlock air_drag.

// Flap control
clearScreen.
print "Flap control" at (0, 0).
until ship:altitude < min_altitude
{
    // Pitch
    local pitch_ster is pitch_pid:update(time:seconds, pitch_error).
    local roll_ster is roll_pid:update(time:seconds, roll_error).
    move_flaps(pitch_ster, roll_ster).

    // Log
    log pitch_error + ";" + pitch_ster + ";" + period(pitch_error) to ship_log.txt.

    // DEBUG
    //draw_arrows(list((ship:facing + r(90, 0, 0)):forevector, ship:facing:forevector)).
    print "Pitch error: " + pitch_error at(0, 14).
    print "Roll error:  " + roll_error at (0, 15).
    // print pitch_ster at (0, 16).

    wait 0.
}

// LANDING LETSS GOO!!
{
    clearScreen.
    print "Landing".

    // // SAS
    // sas on.
    // wait 0.
    // set sasMode to "RETROGRADE".
    // when sasMode <> "RETROGRADE" then
    // {
    //     set sasMode to "RETROGRADE".
    //     preserve.
    // }

    // Flip'n'burn
    move_flaps(29, 0).   // Set flaps to neutral

    rcs on.
    set navMode to "SURFACE".
    stage.
    local twr is 1.2.
    lock throttle to twr * ship:mass * constant:g0 / ship:availablethrust.
    local steering_target is "RETROGRADE".
    lock steering to ship:retrograde.

    // calculate exact thrust
    when vAng(ship:facing:forevector, up:forevector) < 10 then
    {
        local ship_height is 10.
        lock throttle to ship:mass * (ship:verticalspeed^2 * 0.5 / (alt:radar - ship_height) + constant:g0) / ship:availablethrust.
        move_flaps(0, 0).   // Set flaps to neutral
    }

    local horizontal_speed_threshold is 2.

    // Velocity too small to rely on retrograde
    when ship:groundspeed < horizontal_speed_threshold then
    {
        set steering_target to "UP        ".
        lock steering to up.
    }

    when ship:groundspeed >= horizontal_speed_threshold then
    {
        set steering_target to "RETROGRADE".
        lock steering to ship:retrograde.
    }

    // Time to extend gear
    local extension_time is 1.5.
    lock estimated_time to 2 * alt:radar / ship:verticalspeed.
    when estimated_time <= extension_time then
    {
        gear on.
    }

    local prt to SHIP:PARTSTAGGED("fl_flap")[0]:getmodule("modulecontrolsurface").
    // Detecting landing
    until ship:status = "LANDED"
    {
        print "Status: " + ship:status + "      " at (0, 5).
        print "Lock:   " + steering_target at (0, 6).
        print prt:allfieldnames at (0, 10).
    }
    unlock throttle.
}

wait 3.
