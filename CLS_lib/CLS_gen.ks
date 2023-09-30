// CLS_Gen.ks - A library of general functions for the CLS (Common Launch Script)
// Copyright © 2021 Qwarkk6
// Lic. CC-BY-SA-4.0 

@lazyglobal off.

// Controls Warp rate. Prevents warp going over 2x to maintain code stability
Function warpControl {
	parameter runmode.
	local runmodeList is list(-666,-2,0,1,2,3,4,5,6,7).
	local warpLimit is list(0,0,0,1,1,1,0,1,0,1).
	
	// At pre-launch if liftoff time is over a minute away
	If runmode = 0 {
		if time:seconds - launchtime < -120 {
			if warp > 3 {
				set warp to 3.
			}
		} else {
			if warp > 0 {
				set warp to 0.
			}
		}
	//During staging
	} else if staginginprogress or ImpendingStaging {
		if warp > 0 {
			set warp to 0.
		}
	//When the script finishes
	} else if launchcomplete {
		if warp > 0 {
			set warp to 0.
		}
	//If circularisation burn is over 90 seconds away
	} else if runmode = 5 and ship:altitude > body:atm:height and time:seconds < burnStartTime-90 {
		if warp > 3 {
			set warp to 3.
		}
	//If circularisation burn is over 45 seconds away
	} else if runmode = 5 and ship:altitude > body:atm:height and time:seconds < burnStartTime-45 {
		if warp > 2 {
			set warp to 2.
		}
	//runmode specific warp limit
	} else {
		if warp > warpLimit[runmodeList:find(runmode)] {
			set warp to warpLimit[runmodeList:find(runmode)].
		}
	}
}

// Takes a "hh:mm:ss" input for a specific launch time and calculates seconds until this time.
Function secondsToLaunch {
	Parameter input.
	Local inputString is input:tostring.
	Local timeString is time:seconds:tostring.
	
	if inputString:contains(":") {
		local Hours is inputString:split(":")[0].
		local Minutes is inputString:split(":")[1].
		local Seconds is inputString:split(":")[2].
		local Ss is "0." + timeString:split(".")[1].
		
		Local TodaySeconds is time:second + Ss:tonumber() + time:minute*60 + time:hour*60*60.
		Local TargetSeconds to Seconds:tonumber() + Minutes:tonumber()*60 + Hours:tonumber()*60*60.
		
		if TargetSeconds <= TodaySeconds+23 {
			Return TargetSeconds + round(body:rotationperiod)*60*60 - TodaySeconds.
		} else {
			Return TargetSeconds - TodaySeconds.
		}
	} else {
		return input.
	}
}

//Figures out real world time (GMT).
Function realWorldTime {
	local rwtime is kuniverse:realtime.
	local years is floor(rwtime/31536000).
	set rwtime to rwtime-(years*31536000).
	local days is floor(rwtime/86400).
	set rwtime to rwtime-(days*86400).
	local hours is floor(rwtime/3600).
	set rwtime to rwtime-(hours*3600).
	local minutes is floor(rwtime/60).
	return hours+1 + "." + minutes.
}