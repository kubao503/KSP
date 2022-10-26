local torques is list(
	-1
	-0.995694827,
	-0.99517411,
	-0.994304875,
	-0.993096698,
	-0.991561426,
	-0.989707817,
	-0.987547079,
	-0.985087115,
	-0.982337871,
	-0.979305121,
	-0.975996721,
	-0.972415842,
	-0.968568887,
	-0.964458113,
	-0.960086572,
	-0.955455997,
	-0.950569423,
	-0.945425975,
	-0.940026011,
	-0.934366994,
	-0.928272836,
	-0.921095605,
	-0.912589056,
	-0.902548307,
	-0.89077947,
	-0.87709703,
	-0.861329459,
	-0.843315535,
	-0.822905748,
	-0.799964036,
	-0.772406982,
	-0.73475739,
	-0.688342226,
	-0.634905424,
	-0.576106298,
	-0.513536943,
	-0.448718224,
	-0.383103983,
	-0.318039708,
	-0.254771472,
	-0.194413159,
	-0.1379616,
	-0.086284939,
	-0.040148778,
	0,
	0.040148778,
	0.086284939,
	0.1379616,
	0.194413159,
	0.254771472,
	0.318039708,
	0.383103983,
	0.448718224,
	0.513536943,
	0.576106298,
	0.634905424,
	0.688342226,
	0.73475739,
	0.772406982,
	0.799964036,
	0.822905748,
	0.843315535,
	0.861329459,
	0.87709703,
	0.89077947,
	0.902548307,
	0.912589056,
	0.921095605,
	0.928272836,
	0.934366994,
	0.940026011,
	0.945425975,
	0.950569423,
	0.955455997,
	0.960086572,
	0.964458113,
	0.968568887,
	0.972415842,
	0.975996721,
	0.979305121,
	0.982337871,
	0.985087115,
	0.987547079,
	0.989707817,
	0.991561426,
	0.993096698,
	0.994304875,
	0.99517411,
	0.995694827,
	1
).


global MaxTorque is 1.


local function LinearInterpolation
{
	parameter left.
	parameter right.
	parameter value.
	return (value - torques[left]) / (torques[right] - torques[left]) + left.
}


local function BinarySearch
{
	parameter value.
    local left is 0.
    local right is torques:length - 1.

    until right - left = 1
	{
        //set searchedIndex to Math.floor((lewo + prawo) / 2);
        set middle to floor((left + right) / 2).
        if (torques[middle] < value)
		{
            set left to middle.
        }
		else
		{
            set right to middle.
        }
    }

	//print "Value: " + value.
	//print "Left: " + left + ", value: " + torques[left].
	//print "Right: " + right + ", value: " + torques[right].

	//print "Interpolation: " + linear_interpolation(left, right, value).
	return LinearInterpolation(left, right, value).
}


function TorqueToAngle
{
	parameter torque.
	return BinarySearch(torque) - defaultDeployAngle.
}
