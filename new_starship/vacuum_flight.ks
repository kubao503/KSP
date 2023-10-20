@lazyGlobal off.

runOncePath("single_flaps.ks").

local minFlapDrag is 0.5.

function vacuumFlight {
    rcs on.
    lock steering to vectorExclude(ship:velocity:surface, up:forevector).

    until getAvgDrag() > minFlapDrag {
        print "drag " + getAvgDrag() at (0, 13).
    }
    //wait until getAvgDrag() > minFlapDrag.

    rcs off.
    unlock steering.
}
