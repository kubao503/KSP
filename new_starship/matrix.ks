@lazyGlobal off.

local matrixRow1 is v(0,0,0).
local matrixRow2 is v(0,0,0).

function printMatrix {
    parameter position is 5.
    clearScreen.
    print "|" + matrixRow1:x + " | " + matrixRow1:y + "|" at (0, position).
    print "|" + matrixRow2:x + " | " + matrixRow2:y + "|" at (0, position+1).
}

function init2DTransformationMatrix {
    parameter unitVector1, unitVector2.

    local determinant is unitVector1:x * unitVector2:y - unitVector1:y * unitVector2:x.
    set matrixRow1 to v(unitVector2:y, -unitVector2:x, 0) / determinant.
    set matrixRow2 to v(-unitVector1:y, unitVector1:x, 0) / determinant.
    printMatrix().
}

function getTransformedVector {
    parameter vector.
    return v(matrixRow1:x * vector:x + matrixRow1:y * vector:y,
             matrixRow2:x * vector:x + matrixRow2:y * vector:y,
             0).
}
