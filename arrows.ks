@lazyGlobal off.

local arrorList is list().

local function updateColors {
    from {local i is 0.} until i = arrorList:length step {set i to i+1.} do {
        set arrorList[i]:color to hsv(i/arrorList:length , 1, 1).
    }
}

function addArrow {
    parameter start.
    parameter vec.
    parameter scale is 1.
    parameter width is 0.2.
    arrorList:add(vecDraw(start, vec, rgb(1,1,1), "", scale, True, width)).
    updateColors().
}
