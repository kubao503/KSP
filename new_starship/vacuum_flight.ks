@lazyGlobal off.

runOncePath("single_flaps.ks").

local minFlapDrag is 0.3.

function vacuumFlight {
    parameter setPoint.

    lock pitchAxis to vcrs(ship:velocity:surface, up:forevector).
    lock pitch to angleAxis(setPoint, pitchAxis).
    lock mainDirection to vectorExclude(ship:velocity:surface, up:forevector).
    lock upVec to vcrs(pitchAxis, mainDirection).
    lock steering to lookDirUp(pitch * mainDirection, upVec).
    rcs on.

    until getAvgDrag() > minFlapDrag {
        print "drag " + getAvgDrag() at (0, 13).
    }

    rcs off.
    unlock steering.
    unlock upVec.
    unlock mainDirection.
    unlock pitch.
    unlock pitchAxis.
}
