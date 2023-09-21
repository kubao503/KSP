@lazyGlobal off.

runpath("landing_sim.ks").
runpath("Library/Physics.ks").

function land {
    // CONSTANTS
    local gearExtendTime is 7.
    local continentHeight is 20.
    local shipComHeight is 20.17.

    local results is lexicon().
    local kscSqrDistance is 0.
    local oldKscSqrDistance is 0.
    local kscSqrDistanceChange is 0.

    updateResults(True).

    local thrott is 0.

    function updateKscDistance {
        set oldKscSqrDistance to kscSqrDistance.
        set kscSqrDistance to (results["impactGeoPosition"]:position - waypoint("KSC"):position):sqrMagnitude.
        set kscSqrDistanceChange to kscSqrDistance - oldKscSqrDistance.
    }

    function updateResults {
        parameter forceUpdate is False.
        if landingSimFX["impact"]() or forceUpdate {
            set results to landingSimFX["getResults"]().
            updateKscDistance().
        }
    }

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
        updateResults().
    }

    function manualFlight {
        stageTitle("WAITING FOR STAGE SEPARATION").
        wait until stage:number = 0.
    }

    function orientForBoostBackBurn {
        sas off.
        lock boostBackDir to heading(waypoint("KSC"):geoposition:heading, 0).
        lock steering to boostBackDir.

        lock throttle to thrott.
        set thrott to 0.1.

        wait until vang(ship:facing:forevector, boostBackDir:forevector) < 15.
    }

    function executeBoostBackBurn {

        set thrott to 1.

        until results["impactAltitude"] >= continentHeight and results["TTI"] > 1e-3 and kscSqrDistanceChange >= 0 {
            landingSimFX["freeFall"]().
            updateResults().
            set thrott to 1.6e-5 * sqrt(kscSqrDistance) + 0.05.

            print "Impact altitude: " + results["impactAltitude"] at (0, 20).
            print "Time to impact: " + results["TTI"] at (0, 21).
            print "Sqr distance: " + kscSqrDistance + "                        " at (0, 25).
            print "thrott: " + thrott + "                        " at (0, 28).
            print "Distance change: " + kscSqrDistanceChange + "                 " at (0, 29).
        }

        unlock steering.
    }

    function boostBackBurn {
        stageTitle("BOOST BACK BURN").

        orientForBoostBackBurn().
        executeBoostBackBurn().
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
        when results["burnStartTimeSet"] and TimeStamp():seconds >= results["TTIU"] - gearExtendTime then gear on.
    }

    function waitForLandingBurn {
        stageTitle("WAITING FOR BURN").
        until False {
            landingSimFX["landing"]().
            updateResults().

            local timeToBurn is results["burnStartTime"] - TimeStamp():seconds.
            print "Time to impact: " + (results["TTIU"] - TimeStamp():seconds) at (0, 14).
            print "Time to burn: " + timeToBurn at(0, 15)..
            if results["burnStartTimeSet"] and timeToBurn <= 0 break.
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

        set thrott to 1.

        until ship:status = "LANDED" {
            set thrott to getTargetThrottle().
            print "Throttle: " + thrott at (0, 31).
        }

        set thrott to 0.
    }

    manualFlight().
    boostBackBurn().
    waitForDescentInAtmosphere().

    restartSimulation().

    setGearTrigger().
    waitForLandingBurn().
    landingBurn().
}

land().
