@lazyGlobal off.
runOncePath("arrows.ks").

local targetFuelTankPosition is -0.29. // Rises towards the engine

function roundVec {
    parameter vec, digits.
    return v(round(vec:x, digits), round(vec:y, digits), round(vec:z, digits)).
}

function setFuelTankPosition {
    parameter targetPosition.

    function getFuelTanks {
        local allResources is list().
        list resources in allResources.
        local tanks is list().
        for resource in allResources {
            if resource:name = "LiquidFuel" {
                for part in resource:parts {
                    tanks:add(part).
                }
            }
        }
        return tanks.
    }

    function getFuelTankPosition {
        parameter fuelTank.
        return (-ship:facing * fuelTank:position):z.
    }

    local fuelTanks is getFuelTanks().
    local mainFuelTank is fuelTanks[1].
    local headerFuelTank is fuelTanks[0].

    local fuelTransfer is transferAll("LiquidFuel", headerFuelTank, mainFuelTank).
    local oxidizerTransfer is transferAll("Oxidizer", headerFuelTank, mainFuelTank).
    local transferEndCondition is {return targetPosition <= getFuelTankPosition(mainFuelTank).}.

    if targetPosition < getFuelTankPosition(mainFuelTank) {
        set fuelTransfer to transferAll("LiquidFuel", mainFuelTank, headerFuelTank).
        set oxidizerTransfer to transferAll("Oxidizer", mainFuelTank, headerFuelTank).
        set transferEndCondition to {return targetPosition >= getFuelTankPosition(mainFuelTank).}.
    }

    clearScreen. clearVecDraws().

    set fuelTransfer:active to true.
    set oxidizerTransfer:active to true.

    until transferEndCondition() {
        print round(getFuelTankPosition(mainFuelTank), 3) at (0, 5).
        if not fuelTransfer:active {
            print "Fuel transfer fail" at (0, 6).
            break.
        }
    }

    set fuelTransfer:active to false.
    set oxidizerTransfer:active to false.
}

setFuelTankPosition(targetFuelTankPosition).
