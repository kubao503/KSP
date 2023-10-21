@lazyGlobal off.

runOncePath("fuel_balancing.ks").
runOncePath("vacuum_flight.ks").
runOncePath("flap_flight.ks").

balanceFuel().
setMaxDragForAll().
vacuumFlight(-5).
flapFlight(0).
