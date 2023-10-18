@lazyGlobal off.
runOncePath("0:/arrows.ks").
runOncePath("matrix.ks").

clearScreen. clearVecDraws().

local lever1 is ship:partstagged("fl_flap")[0]:position.
local lever2 is ship:partstagged("fr_flap")[0]:position.

init2DTransformationMatrix(-ship:facing * lever1, -ship:facing * lever2).
local torque is v(11, 0, 15).
local transformedTorque is getTransformedVector(torque).

local scale is 1.

addArrow(v(0,0,0), {return lever1.}, scale, 0.1).
addArrow(v(0,0,0), {return lever2.}, scale, 0.1).

addArrow(v(0,0,0), {return ship:facing * torque.}, scale).
addArrow(v(0,0,0), {return transformedTorque:z * lever2.}, scale).
addArrow(v(0,0,0), {return transformedTorque:x * lever1.}, scale).

wait until false.
