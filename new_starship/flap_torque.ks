@lazyGlobal off.
runOncePath("0:/arrows.ks").
runOncePath("matrix.ks").

clearScreen. clearVecDraws().

local lever1 is ship:partstagged("fl_flap")[0]:position.
local lever2 is ship:partstagged("fr_flap")[0]:position.
init2DTransformationMatrix(-ship:facing * lever1, -ship:facing * lever2).

local transformedTorque is v(0,0,0).
addArrow(v(0,0,0), {return transformedTorque:z * lever2.}).
addArrow(v(0,0,0), {return transformedTorque:x * lever1.}).

function setTorque {
    parameter pitchTorque, rollTorque.
    local totalTorque is v(rollTorque, 0, pitchTorque).
    set transformedTorque to getTransformedVector(totalTorque).
}
