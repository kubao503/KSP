@lazyGlobal off.

local logName is "pid_log.txt".
deletePath(logName).

function logPidOutput {
    parameter pid.
    log pid:pTerm + ";" + pid:iTerm + ";" + pid:dTerm to logName.
}
