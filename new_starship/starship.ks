@lazyGlobal off.

runOncePath("fuel_balancing.ks").
runOncePath("flap_pid.ks").

balanceFuel().
flapFlight().
