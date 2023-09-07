local bodyName is ship:body.
local bodyRadius is bodyName:radius.                                                            // The radius of the current celestial body in meters
local bodyMu is bodyName:mu.                                                                    // Standard gravitational parameter of the current body μ (GM)

function getGravity {
    // PRIVATE getGravity :: float -> float
    // Returns gravitational acceleration in m/s^2 in relation to altitude above MSL
    // NOTE -> Parameter s0 is ALTITUDE, not radius
    parameter       s0.

    set gravAccel to bodyMu/(s0+bodyRadius)^2.
    return gravAccel.
}
