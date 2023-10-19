@lazyGlobal off.

local dir is "0:/new_starship/".
runOncePath(dir + "fuel_balancing.ks").
runOncePath(dir + "flap_pairs.ks").

local pidParams is list(1.2, 0, 0.3).

local pidControllers is list().
from {local i is 0.} until i = getFlapCount() step {set i to i+1.} do {
    pidControllers:add(pidLoop(pidParams[0], pidParams[1], pidParams[2])).
    print pidControllers[i]:setpoint.
}

until false {
    from {local i is 0.} until i = pidControllers:length step {set i to i+1.} do {
        local error is getPairAngle(i).
        print "error " + error at (0, 17).
        pidControllers[i]:update(time:seconds, error).
        local torque is pidControllers[i]:output.
        setPairTorque(i, torque).
    }
    wait 0.
}
