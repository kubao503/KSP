@lazyGlobal off.
runOncePath("0:/arrows.ks").
runOncePath("matrix.ks").
runOncePath("flaps.ks").

clearScreen. clearVecDraws().

local lever1 is getFlapPosition(0).
local lever2 is getFlapPosition(1).
init2DTransformationMatrix(-ship:facing * lever1, -ship:facing * lever2).

local transformedTorque is v(0,0,0).
addArrow(v(0,0,0), {return transformedTorque:x * getFlapPosition(0).}).
addArrow(v(0,0,0), {return transformedTorque:z * getFlapPosition(1).}).

function setTorque {
    parameter pitchTorque, rollTorque.
    local totalTorque is v(rollTorque, 0, pitchTorque).
    set transformedTorque to getTransformedVector(totalTorque).
}

until false {
    setTorque(20, -3).
}
