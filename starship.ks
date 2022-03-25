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
    {return plane_vector.},
    {return ship:facing:starvector.}
)).

// PID setup
//      PICH-PID
local p_gain is 2.775.
local i_gain is 1.3875.
local d_gain is 1.3875.
local pitch_pid is pidloop(p_gain, i_gain, d_gain, -35, 35).
set pitch_pid:setpoint to 0.

//      ROLL-PID
local roll_p_gain is 0.6.
local roll_i_gain is 0.
local roll_d_gain is 0.
local roll_pid is pidloop(roll_p_gain, roll_i_gain, roll_d_gain, -3, 3).
set roll_pid:setpoint to 0.


set rotation_d_gain to 4.
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

set SteeringManager:MAXSTOPPINGTIME to 5.

until air_drag > drag_threshold or ship:altitude < max_altitude
{
    // draw_arrows(list(nose_up)).
    print air_drag at (0, 3).
    wait 0.
}
rcs off.
print "" at (0, 3).
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
clearScreen.
print "Landing".

move_flaps(38, 0).
rcs on.
set navMode to "SURFACE".

// SAS
sas on.
wait 0.
set sasMode to "RETROGRADE".

// Engine
stage.
lock throttle to 0.2.

wait until alt:radar < 10.