@lazyGlobal off.
clearScreen.

local flapCount is 4.
local dragFile is "drag_to_angle.txt".

function dragTest {
    function getAeroSurfacesTagged {
        parameter tag.

        local flaps is ship:partsTagged(tag).
        if flaps:length <> flapCount { return list(). }

        local modules is list().
        local moduleName is "ModuleAeroSurface".
        for flap in flaps {
            modules:add(flap:getModule(moduleName)).
        }
        if modules:length <> flapCount { return list(). }

        return modules.
    }

    function setDeployAngles {
        parameter modules, deployAngle.

        local fieldName is "Deploy angle".
        for module in modules {
            module:setField(fieldName, deployAngle).
        }
    }

    function getAverageDrag {
        parameter modules.

        local dragSum is 0.
        local fieldName is "Drag".
        for module in modules {
            set dragSum to dragSum + module:getField(fieldName).
        }

        return dragSum / flapCount.
    }

    function linearInterpolation {
        parameter a, b, t.
        return a * (1-t) + b * t.
    }

    local full_modules is getAeroSurfacesTagged("full_flap").
    local test_modules is getAeroSurfacesTagged("test_flap").

    local testDuration is 40.
    local measurementCount is 100.

    local startTime is timeStamp():seconds.

    from {local i is 0.} until i = measurementCount step {set i to i+1.} do {
        until false {
            local testProgress is (timeStamp():seconds - startTime) / testDuration.
            local angle is linearInterpolation(0, 90, testProgress).
            setDeployAngles(test_modules, angle).
            wait 0.

            local dragRatio is getAverageDrag(test_modules) / getAverageDrag(full_modules).

            print "angle: " + angle at (0, 28).
            print "ratio: " + dragRatio at (0, 29).

            if dragRatio >= (i / measurementCount) {
                log i + ";" + angle to dragFile.
                break.
            }
        }
    }
}

deletePath(dragFile).
wait until ship:dynamicpressure > 0.
dragTest().
