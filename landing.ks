@lazyGlobal off.

runpath("landing_sim.ks").
runpath("Library/Physics.ks").

function land {
    local gearExtendTime is 7.
    local continentHeight is 20.
    local shipComHeight is 20.17.

    local burnStartTime is 0.
    local burnStartTimeSet is False.
    local TTIU is TimeStamp():seconds.                                                                 // Time of impact in universal ksc time
    local TTI is 0.
    local impactAltitude is 0.

    function stageTitle {
        clearScreen.
        parameter text.
        from {local x is terminal:width.} until x = 0 step {set x to x-1.} do {
            set text to text + " ".
        }
        print text at (0, 2).
    }

    function restartSimulation {
        landingSimFX["restartSimulation"]().
        unpackResults().
    }

    function boostBackBurn {
        stageTitle("BOOST BACK BURN").
        lock boostBackDir to heading(waypoint("KSC"):geoposition:heading, 0).
        sas off.
        lock steering to boostBackDir.
        set thrott to 0.1.

        wait until vang(ship:facing:forevector, boostBackDir:forevector) < 12.

        set thrott to 1.
        until impactAltitude >= continentHeight and TTI > 1e-3 {
            landingSimFX["freeFall"]().
            unpackResults().
            print "Impact altitude: " + impactAltitude at (0, 20).
            print "Time to impact: " + TTI at (0, 21).
        }
        unlock steering.
    }

    function waitForDescentInAtmosphere {
        stageTitle("WAITING FOR DESCENT IN ATMOSPHERE").

        set thrott to 0.
        brakes on.
        gear off.
        lock steering to (-1) * ship:velocity:surface.

        wait until ship:dynamicpressure > 0 and ship:verticalspeed < -50.
    }

    function setGearTrigger {
        when burnStartTimeSet and TimeStamp():seconds >= TTIU - gearExtendTime then gear on.
    }

    function unpackResults {
        set burnStartTime to landingSimFX["getResults"]()["Burn start time"].
        set burnStartTimeSet to landingSimFX["getResults"]()["Burn start time set"].
        set TTIU to landingSimFX["getResults"]()["Time of Impact"].
        set TTI to landingSimFX["getResults"]()["Time to Impact"].
        set impactAltitude to landingSimFX["getResults"]()["Height MSL"].
    }

    function waitForLandingBurn {
        stageTitle("WAITING FOR BURN").
        until False {
            landingSimFX["landing"]().
            unpackResults().

            local timeToBurn is burnStartTime - TimeStamp():seconds.
            print "Time to impact: " + (TTIU - TimeStamp():seconds) at (0, 14).
            print "Time to burn: " + timeToBurn at(0, 15).
            if burnStartTimeSet and timeToBurn <= 0 break.
        }
    }

    function getHeightAboveGround {
        return (altitude-geoposition:terrainheight) - shipComHeight.
    }

    function getTargetThrottle {
        local height is getHeightAboveGround().
        print "Height: " + height at (0, 30).
        local targetThrust is (ship:airspeed^2 / 2 / height + getGravity(height/2)) * ship:mass.
        return targetThrust / ship:maxThrust.
    }

    function landingBurn {
        stageTitle("LANDING BURN").

        until ship:status = "LANDED" {
            set thrott to getTargetThrottle().
            print "Throttle: " + thrott at (0, 31).
        }
    }

    stageTitle("WAITING FOR STAGE SEPARATION").
    wait until stage:number = 0.

    local thrott is 0.
    lock throttle to thrott.

    boostBackBurn().

    waitForDescentInAtmosphere().

    restartSimulation().
    setGearTrigger().
    waitForLandingBurn().
    set thrott to 1.
    landingBurn().
    set thrott to 0.
}

land().
