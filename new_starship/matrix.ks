@lazyGlobal off.

local matrixRow1 is v(0,0,0).
local matrixRow2 is v(0,0,0).

function printMatrix {
    parameter position is 5.
    clearScreen.
    print "|" + matrixRow1:x + " | " + matrixRow1:z + "|" at (0, position).
    print "|" + matrixRow2:x + " | " + matrixRow2:z + "|" at (0, position+1).
}

function init2DTransformationMatrix {
    parameter unitVector1, unitVector2.

    local determinant is unitVector1:x * unitVector2:z - unitVector1:z * unitVector2:x.
    set matrixRow1 to v(unitVector2:z, 0, -unitVector2:x) / determinant.
    set matrixRow2 to v(-unitVector1:z, 0, unitVector1:x) / determinant.
}

function getTransformedVector {
    parameter vector.
    return v(matrixRow1:x * vector:x + matrixRow1:z * vector:z,
             0,
             matrixRow2:x * vector:x + matrixRow2:z * vector:z).
}
