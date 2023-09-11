@lazyGlobal off.

runpath("landing_sim.ks").
runpath("Library/Physics.ks").

function land {
    local gearExtendTime is 7.
    local continentHeight is 10.

    local burnStartTimeSet is False.
    local TTIU is TimeStamp():seconds.                                                                 // Time of impact in universal ksc time
    local TTI is 0.
    local impactAltitude is 0.

    local thrott is 0.
    lock throttle to thrott.

    function boostBackBurn {
        lock boostBackDir to heading(waypoint("KSC"):geoposition:heading, 0).
        lock steering to boostBackDir.
        set thrott to 0.1.

        wait until vang(ship:facing:forevector, boostBackDir:forevector) < 10.

        set thrott to 1.
        until impactAltitude >= continentHeight and TTI > 0 {
            landingSimFX["freeFall"]().
            unpackResults().
            print "Impact altitude: " + impactAltitude at (0, 20).
            print "Time to impact: " + TTI at (0, 21).
        }
        unlock steering.
    }

    function setGearTrigger {
        when burnStartTimeSet and TimeStamp():seconds >= TTIU - gearExtendTime then gear on.
    }

    local burnStartTime is 0.

    function unpackResults {
        set burnStartTime to landingSimFX["getResults"]()["Burn start time"].
        set burnStartTimeSet to landingSimFX["getResults"]()["Burn start time set"].
        set TTIU to landingSimFX["getResults"]()["Time of Impact"].
        set TTI to landingSimFX["getResults"]()["Time to Impact"].
        set impactAltitude to landingSimFX["getResults"]()["Height MSL"].
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

    wait until stage:number = 0.

    boostBackBurn().

    set thrott to 0.
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
