@lazyGlobal off.
clearScreen. clearVecDraws().
runOncePath("arrows.ks").

local targetFuelTankPosition is -0.5. // Rises towards the engine

local allResources is list().
list resources in allResources.
local fuelTanks is list().
for resource in allResources {
    if resource:name = "LiquidFuel" {
        for part in resource:parts {
            fuelTanks:add(part).
        }
    }
}
local mainFuelTank is fuelTanks[1].

function roundVec {
    parameter vec, digits.
    return v(round(vec:x, digits), round(vec:y, digits), round(vec:z, digits)).
}

function getFuelTankPosition {
    parameter fuelTank.
    return (-ship:facing * fuelTank:position):z.
}

function setFuelTankPosition {
    parameter targetPosition.

    local fuelTransfer is transferAll("LiquidFuel", fuelTanks[0], fuelTanks[1]).
    local oxidizerTransfer is transferAll("Oxidizer", fuelTanks[0], fuelTanks[1]).
    local transferEndCondition is {return targetPosition <= getFuelTankPosition(mainFuelTank).}.

    if targetPosition < getFuelTankPosition(mainFuelTank) {
        set fuelTransfer to transferAll("LiquidFuel", fuelTanks[1], fuelTanks[0]).
        set oxidizerTransfer to transferAll("Oxidizer", fuelTanks[1], fuelTanks[0]).
        set transferEndCondition to {return targetPosition >= getFuelTankPosition(mainFuelTank).}.
    }

    set fuelTransfer:active to true.
    set oxidizerTransfer:active to true.

    until transferEndCondition() or not fuelTransfer:active {
        print round(getFuelTankPosition(mainFuelTank), 3) at (0, 5).
    }

    set fuelTransfer:active to false.
    set oxidizerTransfer:active to false.
}
addArrow(v(0,0,0), {return mainFuelTank:position.}).

setFuelTankPosition(targetFuelTankPosition).
