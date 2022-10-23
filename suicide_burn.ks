local flight_phase is 1.
clearscreen.

set thrott to 0.
lock throttle to thrott.

set RADAR_OFFSET to 20.
set GEAR_EXTEND_TIME to 7.
set BURN_ALTITUDE_COEFF to 0.9.
set g to kerbin:mu / kerbin:radius^2.

lock real_alt to (alt:radar - RADAR_OFFSET).

// Wait for correct altitude to start calculations
wait until ship:altitude < 30000.

print "STARTING CALCULATIONS...".

// burn calculations
lock max_acceleration to min(ship:maxthrust / ship:mass - g, 3 * g).
lock burn_altitude to ship:verticalspeed^2 / max_acceleration / 2.


// burn trigger
when alt:radar < burn_altitude * BURN_ALTITUDE_COEFF then
{
    set flight_phase to 2.
    clearScreen.
    print "BURN...".

    unlock max_acceleration.
    unlock burn_altitude.

    lock thrott to ship:mass * ship:verticalspeed^2 / real_alt / ship:maxthrust.
    lock time_to_impact to sqrt(2 * real_alt / (ship:maxthrust * throttle / ship:mass - g)).

    // Landing gear
    when time_to_impact < GEAR_EXTEND_TIME then
    {
        set flight_phase to 3.

        unlock time_to_impact.
        gear on.
    }

    // Engine off
    when real_alt <= 1 then
    {
        set flight_phase to 4.
        clearScreen.
        print "LANDED...".

        set thrott to 0.
    }
}

// printing info
until false
{
    if flight_phase = 1
    {
        // print "gravitional acceleration: " + g at (0, 15).
        print "acceleration: " + max_acceleration at (0, 16).
        print "BURN ALTITUDE: " + burn_altitude at (0, 17).
        // print "vertical speed^2: " + ship:verticalspeed^2 at (0, 18).
        // print "mass: " + ship:mass at (0, 19).
        // print "thrust: " + ship:maxthrust at (0, 20).
    }
    if flight_phase = 2 or flight_phase = 3
    {
        print "throttle: " + thrott at (0, 18).
        print "radar: " + alt:radar at (0, 19).

        if flight_phase = 2
        {
            print "time to impact: " + time_to_impact at(0, 20).
        }
    }

    wait 1.
}
