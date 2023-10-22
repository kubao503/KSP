@lazyGlobal off.

function balanceFuel {
    local targetPosition is -0.2646875. // Rises towards the engine

    local fuelNames is uniqueSet("LiquidFuel", "Oxidizer").

    function getTransferedResources {
        local allResources is list().
        list resources in allResources.
        local correctResources is list().

        for resource in allResources {
            if fuelNames:contains(resource:name) {
                correctResources:add(resource).
            }
        }
        
        return correctResources.
    }

    local transferedResources is getTransferedResources().

    function getFuelTanks {
        return transferedResources[0]:parts.
    }

    function getMassToAmounts {
        local massToAmount is lexicon().
        local currentAmounts is lexicon().

        for resource in transferedResources {
            currentAmounts:add(resource:name, resource:amount).
        }

        for currentRes in transferedResources {
            local densityAmountRatioSum is 0.
            for otherRes in transferedResources {
                set densityAmountRatioSum to densityAmountRatioSum
                    + currentRes:density * currentAmounts[otherRes:name] / currentAmounts[currentRes:name].
            }
            massToAmount:add(currentRes:name, 1/densityAmountRatioSum).
        }

        return massToAmount.
    }

    function allTransfersInactive {
        parameter transfers.
        for transfer in transfers {
            if transfer:active {
                return false.
            }
        }
        return true.
    }

    function getFuelTankPosition {
        parameter fuelTank.
        return (-ship:facing * fuelTank:position):z.
    }

    local fuelTanks is getFuelTanks().
    local mainFuelTank is fuelTanks[1].
    local headerFuelTank is fuelTanks[0].

    local massToAmounts is getMassToAmounts().
    local fuelTransfers is list().

    local totalMassTransfer is (getFuelTankPosition(mainFuelTank) - targetPosition)
                    / (getFuelTankPosition(mainFuelTank) - getFuelTankPosition(headerFuelTank))
                    * ship:mass.

    local source is headerFuelTank.
    local destination is mainFuelTank.

    if totalMassTransfer < 0 {
        set source to mainFuelTank.
        set destination to headerFuelTank.
    }

    for name in fuelNames {
        local amount is abs(totalMassTransfer) * massToAmounts[name].
        local fuelTransfer is transfer(name, source, destination, amount).
        set fuelTransfer:active to true.
        fuelTransfers:add(fuelTransfer).
    }

    until allTransfersInactive(fuelTransfers) {
        print "Fuel balance: " + getFuelTankPosition(mainFuelTank) at (0, 5).
    }

    for transfer in fuelTransfers {
        if transfer:status = "Failed" {
            print "FUEL TRANSFER FAIL" at (0, 6).
        }
    }
}
