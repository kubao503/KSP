@lazyGlobal off.
clearScreen.

local flapCount is 4.
local dragFile is "drag_log.txt".

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

    local full_modules is getAeroSurfacesTagged("full_flap").
    local test_modules is getAeroSurfacesTagged("test_flap").

    local angle is 0.
    until angle > 90 {
        setDeployAngles(test_modules, angle).
        wait 0.5.

        print "angle: " + angle at (0, 28).
        log angle + ";" + (getAverageDrag(test_modules) / getAverageDrag(full_modules)) to dragFile.

        set angle to angle + 1.
    }
}

deletePath(dragFile).
wait until ship:dynamicpressure > 0.
dragTest().
