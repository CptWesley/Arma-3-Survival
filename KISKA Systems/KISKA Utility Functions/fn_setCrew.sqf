/* ----------------------------------------------------------------------------
Function: KISKA_fnc_setCrew

Description:
	Moves units into a vehicle as crew and then as passengers.

Parameters:
	0: _crew : <GROUP, ARRAY, or OBJECT> - The units to move into the vehicle
	1: _vehicle : <OBJECT> - The vehicle to put units into
	2: _deleteCrewIfNull : <BOOL> - If the vehicle turns out to be null, the provided crew will be deleted

Returns:
	<BOOL> - True if crew was set, false if problem encountered

Examples:
    (begin example)
		[_group1,_vehicle] call KISKA_fnc_setCrew;
    (end)

Author:
	Ansible2
---------------------------------------------------------------------------- */
scriptName "KISKA_fnc_setCrew";

if (!canSuspend) exitWith {
	_this spawn KISKA_fnc_setCrew;
};


params [
	["_crew",grpNull,[[],grpNull,objNull]],
	["_vehicle",objNull,[objNull]],
	["_deleteCrewIfNull",true,[true]]
];


if (_crew isEqualType grpNull) then {_crew = units _crew};

if (_crew isEqualType objNull) then {_crew = [_crew]};

if (_crew isEqualTo []) exitWith {
	[["Found that ",_crew," is not defined, exiting..."],true] call KISKA_fnc_log;
	false
};

if (isNull _vehicle OR {!(alive _vehicle)}) exitWith {
	[["Found that ",_vehicle," is either null or dead already, exiting..."]] call KISKA_fnc_log;

	if (_deleteCrewIfNull) then {
		[["Deleting crew of null vehicle: ",_crew]] call KISKA_fnc_log;
		_crew apply {
			deleteVehicle _x;
		};
	};

	false
};


// crew moved in too fast after init seems to be unreliable
// they may not end up in the vehicle
sleep 0.5;
_crew apply {
	private _movedIn = _x moveInAny _vehicle;

	if !(_movedIn) then {
		[["Deleted excess unit: ",_x]] call KISKA_fnc_log;
		deleteVehicle _x
	};
};


true
