//kOS terminal readouts
function chuteHUD {
	Print "Re-entry Procedure" at (0,0).
	Print "Status: " + shipStatus + " (" + runmode + ")               " at (0,1).
	Print "RCS: " + padding(rcsFuel,2,1,false) + "% | EC: " +  padding(EC,2,1,false) + "%   " at (0,2).
	Print "------------------" at (0,3).
	Print "Dynamic Pressure: " + padding(ship:Q*constant:atmtokpa*1000,5,1,false) + "Pa   " at (0,4).
	Print "Drogue Max-Q: " + padding(drogueMaxQ,5,1,false) + "Pa   " at (0,5).
	Print "Chute Max-Q: " + padding(chuteMaxQ,5,1,false) + "Pa   " at (0,6).
	Print "Alt Pressure: " + padding(Body:atm:altitudepressure(ship:altitude),1,3,false) + "Atm   " at (0,7).
	Print "------------------" at (0,8).
	Print "Altitude: " + padding(alt:radar,4,1,false) + "m   " at (0,9).
	Print "Descent Time: " + padding(descentTime,3,1,false) + "s   " at (0,10).
	Print "Remaining Time: " + padding(max(impactTime,0),3,1,false) + "s        " at (0,11).
	Print "Descent Speed: " + padding(descentSpeed,3,1,false) + "m/s   " at (0,12).
	Print "------------------" at (0,13).
	Print "Drogue Status: " + drogueStatus + "        " at (0,14).
	Print "Chute Status: " + chuteStatus + "        " at (0,15).
	Print "Fuel Cell Status: " + fuelCellStatus + "      " at (0,16).
	if homeconnection:isconnected {
		Print "Signal Status: Connected" at (0,17).
	} else {
		Print "Signal Status: LoS      " at (0,17).
	}
	Print "------------------" at (0,18).
	Print "Drogue Chutes: " + stockDrogueList:length at (0,19).
	Print "Mains Chutes: " + stockChuteList:length at (0,20).
}

//Main calculations
function Calculations {
	if ship:altitude < body:atm:height and ship:verticalspeed < 0 {
		set descentSpeed to ship:velocity:surface:mag.
		set descentTime to time:seconds - entrytime.
		set impactDistance to (ship:altitude-ship:geoposition:terrainheight)*(SIN(90)/SIN(pitch_for_vector(ship:srfretrograde:vector))).
		set impactTime to impactDistance / descentSpeed.
	} else {
		set descentTime to 0.
		set descentSpeed to 0.
		set impactTime to 0.
	}
}

//Resource monitoring
function chuteResourceTracker {	
	list resources in shipResList.
	if shipResList:join(","):contains("Aerozine50") {
		For res in ship:resources {
			if res:Name = "Aerozine50" {
				set rcsFuel to (Res:Amount/Res:Capacity)*100.
			}
		}
	} else {
		set rcsFuel to 0.
	}
} 

//Tracks dynamic pressure to determine when chutes can be opened
function dynamicPressureTracker {
	parameter dyPr.
	
	if dyPr = 99999999 {
		global dyPr is ship:Q * constant:atmtokpa * 1000.
	}
	if time:Seconds > dyPrTime {
		if ship:Q * constant:atmtokpa * 1000 < dyPr {
			global dyPr is ship:Q * constant:atmtokpa * 1000.
			global dyPrTime is time:seconds+0.5.
			return "Decreasing".
		} else {
			global dyPr is ship:Q * constant:atmtokpa * 1000.
			global dyPrTime is time:seconds+0.5.
			return "Increasing".
		}
	}
}