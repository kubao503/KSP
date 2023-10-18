@lazyGlobal off.

runOncePath("flaps.ks").

local pairs is list(
    list(0, 3),
    list(1, 2)
).

function setPairTorque {
    parameter pairIdx, torque.
    local pair is pairs[pairIdx].

    if torque >= 0 {
        local flapForce is (getFlapDrag(pair[0]) * getFlapPosition(pair[0]):mag - torque) / getFlapPosition(pair[1]):mag.
        setMaxDrag(pair[0]).
        setFlapDrag(pair[1], flapForce).
    } else {
        local flapForce is (getFlapDrag(pair[1]) * getFlapPosition(pair[1]):mag + torque) / getFlapPosition(pair[0]):mag.
        setMaxDrag(pair[1]).
        setFlapDrag(pair[0], flapForce).
    }
}

clearScreen.
until false {
    local torque is 0.1.
    setPairTorque(0, torque).
    setPairTorque(1, -torque).
}
