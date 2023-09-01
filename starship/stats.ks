// Oscilation period
local raising is true.
local last_value is 0.
local last_peak_time is time:seconds.
function Period
{
    parameter value.
    local difference is value - last_value.
    set last_value to value.
    if raising and difference < 0
    {
        set raising to false.
        local calculated_period is time:seconds - last_peak_time.
        set last_peak_time to time:seconds.
        return calculated_period.
    }
    else if not raising and difference > 0
    {
        set raising to true.
    }

    return "".
}
