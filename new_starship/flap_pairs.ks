@lazyGlobal off.

runOncePath("single_flaps.ks").

local pairs is list(
    list(0, 3),
    list(1, 2)
).

local distanceToFlap is list().

from {local flapIdx is 0.} until flapIdx = getFlapCount() step {set flapIdx to flapIdx+1.} do {
    distanceToFlap:add(getFlapPosition(flapIdx):mag).
}

function getFlapPairCount {
    return pairs:length.
}

function getPairAngle {
    parameter pairIdx.
    local pair is pairs[pairIdx].
    return vang(ship:velocity:surface, getFlapPosition(pair[0])) - 90.
}

function setPairTorque {
    parameter pairIdx, torque.
    local pair is pairs[pairIdx].
    if torque >= 0 {
        local flapForce is (getFlapDrag(pair[0]) * distanceToFlap[pair[0]] - torque) / distanceToFlap[pair[1]].
        setMaxDrag(pair[0]).
        setFlapDrag(pair[1], flapForce).
    } else {
        local flapForce is (getFlapDrag(pair[1]) * distanceToFlap[pair[1]] + torque) / distanceToFlap[pair[0]].
        setMaxDrag(pair[1]).
        setFlapDrag(pair[0], flapForce).
    }
}
