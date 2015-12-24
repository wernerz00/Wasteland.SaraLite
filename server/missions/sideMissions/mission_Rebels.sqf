// ******************************************************************************************
// * This project is licensed under the GNU Affero GPL v3. Copyright © 2014 A3Wasteland.com *
// ******************************************************************************************
//	@file Version: 1.0
//	@file Name: mission_VehicleCapture.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, JoSchaap, AgentRev
//	@file Created: 08/12/2012 15:19

if (!isServer) exitwith {};
#include "sideMissionDefines.sqf";

private ["_nbUnits", "_outpost", "_objects"];

_setupVars =
{
	_missionType = "Bandit Base";
	_locationsArray = MissionSpawnMarkers;
	_nbUnits = AI_GROUP_MEDIUM;
};

_setupObjects =
{
	_missionPos = markerPos _missionLocation;
	
		//delete existing base parts and vehicles at location
	_baseToDelete = nearestObjects [_missionPos, ["All"], 25];
		{ deleteVehicle _x } forEach _baseToDelete; 

	_outpost = (call compile preprocessFileLineNumbers "server\missions\outposts\rebelsList.sqf") call BIS_fnc_selectRandom;
	_objects = [_outpost, _missionPos, 0] call createOutpost;

	
	// NPC Randomizer 
_randomGroup = [createGroup1,createGroup2,createGroup3,createGroup4,createGroup5,createGroup6,createGroup7,createGroup8,createGroup9,createGroup10] call BIS_fnc_selectRandom;
_aiGroup  = createGroup CIVILIAN;
[_aiGroup, _missionPos] spawn _randomGroup;
	

	_missionHintText = format ["A group of <t color='%1'>Bandits</t> have been spotted! Find them and take 'em out", sideMissionColor]
};

_waitUntilMarkerPos = nil;
_waitUntilExec = nil;
_waitUntilCondition = nil;

_failedExec =
{
	// Mission failed
	{ deleteVehicle _x } forEach _objects;
};

_successExec =
{
	// Mission complete
	{ _x setVariable ["R3F_LOG_disabled", false, true] } forEach _objects;
	[_locationsArray, _missionLocation, _objects] call setLocationObjects;

	_successHintMessage = "Bandit Group has been cleared. Well done!";
};

_this call sideMissionProcessor;