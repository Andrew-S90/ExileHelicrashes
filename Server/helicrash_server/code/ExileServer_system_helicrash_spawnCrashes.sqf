 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */

private ["_crashes", "_center", "_classnames", "_effects", "_logging", "_markers", "_blacklistPos", "_classname", "_spawnPos", "_heliCrash", "_effect", "_mark"];

try 
{
	_crashes = getNumber(configfile >> "CfgHeliCrash" >> "Settings" >> "HeliCrashes");
	_center = getArray(configfile >> "CfgHeliCrash" >> "Settings" >> worldName);
	_classnames = getArray(configfile >> "CfgHeliCrash" >> "Settings" >> "wrecks");
	_effects = getNumber(configfile >> "CfgHeliCrash" >> "Settings" >> "Effects");
	_logging = getNumber(configfile >> "CfgHeliCrash" >> "Logging" >> "itemLogging");
	_markers = getNumber(configfile >> "CfgHeliCrash" >> "Logging" >> "markers");
	
	if (_crashes == 0) then
	{
		throw "Spawning Heli Crashes turned off";
	};
	
	if(count _center < 1) then
	{
		_center = [[worldSize/2,worldSize/2,0],10000];
	};
	
	_blacklistPos = [];
	for "_i" from 1 to _crashes do
	{
		_classname = selectRandom _classnames;
		_spawnPos = [];
		_spawnPos = [(_center select 0), 0, (_center select 1), 20, 0, 0.25, 0, _blacklistPos,[0,0]] call BIS_fnc_findSafePos;
		_spawnPos pushBack 0;
		_blacklistPos pushBack [_spawnPos,500];
		_heliCrash = createSimpleObject [_classname, ATLToASL _spawnPos];
		
		_heliCrash setDir (random 360);
		_heliCrash setPosATL _spawnPos;
		_heliCrash setVectorUp surfaceNormal position _heliCrash;
		
		if(_effects == 1) then 
		{
			_effect = "test_EmptyObjectForSmoke" createVehicle (position _heliCrash);
			_effectPos = _spawnPos vectorAdd [0,0,-1];
			_effect setPosATL _effectPos;
		};
		
		if (_logging == 1) then
		{
			diag_log format["ExileServer_system_helicrash_spawnCrashes: %1 spawned at %2", _classname, _spawnPos];
		};

		if (_markers == 1) then
		{
			_mark = createmarker [format["Crash Position %1 - 2",_spawnPos], _spawnPos];
			_mark setMarkerShape "ICON";
			_mark setMarkerColor "ColorWhite";
			_mark setMarkerType "KIA";
		};
		
		_spawnPos call ExileServer_system_helicrash_spawnLoot;
	};
}
catch
{
	format ["ExileServer_system_helicrash_spawnCrashes: %1", _exception] call ExileServer_util_log;
};