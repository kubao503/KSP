local normal_part to ship:partsdubbed("Elevon 3").
local no_lift_part to ship:partsdubbed("Wing with no lift").
local fuel to ship:partsdubbed("FL-T800 Fuel Tank")[0].

clearScreen.

print fuel:allmodules().

// print "Normal:".
// for part in normal_part
// {
//     print part:allmodules().
// }

// print "Modified:".
// for part in no_lift_part
// {
//     print part:allmodules().
// }