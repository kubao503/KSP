@lazyGlobal off.

runpath("landing_sim.ks").
runpath("Library/Physics.ks").

function land {
    local gearExtendTime is 7.
    local burnStartTimeSet is False.
    local TTIU is TimeStamp():seconds.                                                                 // Time of impact in universal ksc time

    function setGearTrigger {
        when burnStartTimeSet and TimeStamp():seconds >= TTIU - gearExtendTime then gear on.
    }

    local burnStartTime is 0.

    function unpackResults {
        set burnStartTime to landingSimFX["getResults"]()["Burn start time"].
        set burnStartTimeSet to landingSimFX["getResults"]()["Burn start time set"].
        set TTIU to landingSimFX["getResults"]()["Time of Impact"].
    }

    function waitForBurn {
        until False {
            landingSimFX["landing"]().
            unpackResults().

            local timeToBurn is burnStartTime - TimeStamp():seconds.
            print "Time to impact: " + (TTIU - TimeStamp():seconds) at (0, 14).
            print "Time to burn: " + timeToBurn at(0, 15).
            if burnStartTimeSet and timeToBurn <= 0 return.
        }
    }

    local shipComHeight is 20.17.

    function getHeightAboveGround {
        return (altitude-geoposition:terrainheight) - shipComHeight.
    }

    function getTargetThrottle {
        local height is getHeightAboveGround().
        print "Height: " + height at (0, 30).
        local targetThrust is (ship:airspeed^2 / 2 / height + getGravity(height/2)) * ship:mass.
        return targetThrust / ship:maxThrust.
    }

    function manageBurn {
        until ship:status = "LANDED" {
            set thrott to getTargetThrottle().
            print "Throttle: " + thrott at (0, 31).
        }
    }

    local thrott is 0.
    lock throttle to thrott.
    brakes on.
    gear off.
    sas on.
    wait 0.01.
    set navmode to "surface".
    set sasmode to "retrograde".

    setGearTrigger().

    waitForBurn().
    set thrott to 1.
    manageBurn().
    set thrott to 0.
}

land().
