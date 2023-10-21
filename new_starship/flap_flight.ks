@lazyGlobal off.

clearScreen.

runOncePath("flap_pairs.ks").
runOncePath("pid_log.ks").

local pidParams is list(1.5, 0.3125, 1.8).
local pidControllers is list().

local function pidInit {
    parameter setPoint.
    print "params: " + pidParams[0] + ", " + pidParams[1] + ", " + pidParams[2] at (0, 16).
    from {local i is 0.} until i = getFlapPairCount() step {set i to i+1.} do {
        pidControllers:add(pidLoop(pidParams[0], pidParams[1], pidParams[2])).
        set pidControllers[i]:setPoint to setPoint.
    }
}

function flapFlight {
    parameter setPoint.

    pidInit(setPoint).

    until false {
        from {local i is 0.} until i = pidControllers:length step {set i to i+1.} do {
            local error is getPairAngle(i).
            pidControllers[i]:update(time:seconds, error).
            local torque is pidControllers[i]:output.
            setPairTorque(i, torque).
        }
        // Pid is for some reason giving error with changed sign
        print "error " + round(-pidControllers[0]:error, 5) at (0, 17).
        logPidOutput(pidControllers[0]).
        wait 0.

        //if ship:altitude < 38300 {
            //print "END" at (0, 22).
            //break. 
        //}
    }
}
