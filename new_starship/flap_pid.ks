@lazyGlobal off.

clearScreen.

runOncePath("fuel_balancing.ks").
runOncePath("flap_pairs.ks").
runOncePath("pid_log.ks").

local pidParams is list(1.2, 0, 0.3).

local pidControllers is list().
from {local i is 0.} until i = getFlapCount() step {set i to i+1.} do {
    pidControllers:add(pidLoop(pidParams[0], pidParams[1], pidParams[2])).
    print pidControllers[i]:setpoint.
}

until false {
    from {local i is 0.} until i = pidControllers:length step {set i to i+1.} do {
        local error is getPairAngle(i).
        pidControllers[i]:update(time:seconds, error).
        local torque is pidControllers[i]:output.
        setPairTorque(i, torque).
    }
    print "error " + pidControllers[0]:error at (0, 17).
    logPidOutput(pidControllers[0]).
    wait 0.
}
