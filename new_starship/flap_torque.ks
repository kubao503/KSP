@lazyGlobal off.
runOncePath("arrows.ks").
runOncePath("matrix.ks").

clearScreen. clearVecDraws().

local lever1 is -ship:facing * ship:partstagged("fl_flap")[0]:position.
local lever2 is -ship:facing * ship:partstagged("fr_flap")[0]:position.
//local lever1 is v(1, 0, 1).
//local lever2 is v(-1, 0, 1).

//init2DTransformationMatrix(-ship:facing * lever1, -ship:facing * lever2).
init2DTransformationMatrix(lever1, lever2).
printMatrix().
local torque is v(2, 0, 16).
local transformedTorque is getTransformedVector(torque).
print lever1.

local scale is 7.

addArrow(v(0,0,0), {return ship:facing * lever1.}, scale, 0.1).
addArrow(v(0,0,0), {return ship:facing * lever2.}, scale, 0.1).

addArrow(v(0,0,0), {return ship:facing * torque.}, scale).
addArrow(v(0,0,0), {return transformedTorque:z * (ship:facing * lever2).}, scale).
addArrow(v(0,0,0), {return transformedTorque:x * (ship:facing * lever1).}, scale).
                    


//addArrow(v(0,0,0), {return ship:facing:forevector * lever1 * transformedTorque:x.}, 3).
//addArrow(v(0,0,0), {return lever2 * transformedTorque:y.}, 3).

wait until false.
