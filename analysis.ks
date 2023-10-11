clearScreen. clearVecDraws().
runOncePath("arrows.ks").

local flapsModules is ship:modulesNamed("ModuleAeroSurface").

lock flapPosition to flapsModules[0]:part:position.
addArrow({return v(0,0,0).}, {return flapPosition.}).
addArrow( {return flapPosition.}, {return vxcl(flapPosition, -velocity:surface).}).
addArrow( {return flapPosition.}, {return -velocity:surface.}).

local distanceToCOM is list().
for module in flapsModules {
    // Ship facing is already normalized
    distanceToCOM:add(vdot(module:part:position, ship:facing:topvector)).
}

until false {
    // Ship up is already normalized
    from {local i is 0.} until i = flapsModules:length step {set i to i+1.} do {
        local totalDrag is flapsModules[i]:getField("Drag").
        print distanceToCOM[i] + " " + totalDrag + "           " at (0, 10+i).
    }
    wait 0.
}
