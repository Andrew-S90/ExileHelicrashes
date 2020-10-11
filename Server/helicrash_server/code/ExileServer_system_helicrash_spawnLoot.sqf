 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
 
private ["_heliPosition", "_heliCrashLoot", "_lootMin", "_lootMax", "_secondLootChance", "_lootRadius", "_logging", "_markers", "_boxType", "_items", "_blacklistPos", "_lootNum", "_lootSpawn", "_lootPosition", "_lootHolder", "_classname", "_cargoType", "_magazineClassNames", "_magazineClassName", "_numberOfMagazines", "_mark"]; 
 
_heliPosition = _this; 

try 
{
	if (count _heliPosition < 3) then
	{
		throw "Something is wrong with heli position. No loot will be spawned";
	};

	_heliCrashLoot = getArray(configfile >> "CfgHeliCrash" >> "Loot" >> "HeliCrashCustom");
	_lootMin = getNumber(configfile >> "CfgHeliCrash" >> "Settings" >> "LootMin");
	_lootMax = getNumber(configfile >> "CfgHeliCrash" >> "Settings" >> "LootMax");
	_secondLootChance = getNumber(configfile >> "CfgHeliCrash" >> "Settings" >> "SecondLootChance");
	_lootRadius = getNumber(configfile >> "CfgHeliCrash" >> "Settings" >> "Radius");
	_logging = getNumber(configfile >> "CfgHeliCrash" >> "Logging" >> "itemLogging");
	_markers = getNumber(configfile >> "CfgHeliCrash" >> "Logging" >> "markers");
	
	_fillerLoot = getArray(configfile >> "CfgHeliCrash" >> "Loot" >> "FillerLoot");
	
	_blacklistPos = [];
	_lootNum = floor(random(_lootMax - _lootMin)) + _lootMin;
	
	
	for "_i" from 1 to _lootNum do
	{
		_lootSpawn = 1;
		_lootPosition = [_heliPosition, 0, _lootRadius, 0.5, 0, 0.25, 0, _blacklistPos,[0,0]] call BIS_fnc_findSafePos;
		_lootPosition pushBack 0;
		_blacklistPos pushBack [_lootPosition,0.5];
		
		_lootHolder = createVehicle ["LootWeaponHolder", _lootPosition, [], 0, "CAN_COLLIDE"];
		_lootHolder setDir (random 360);
		_lootHolder setPosATL _lootPosition;
		_lootHolder setVariable ["PermaLoot", true];
		_lootHolder setVectorUp surfaceNormal position _lootHolder;
		
		_roll = floor(random(100));
		
		if(_secondLootChance >= _roll) then 
		{
			_lootSpawn = 2;
		};
		
		for "_i" from 1 to _lootSpawn do
		{
			_classname = selectRandom _heliCrashLoot;
			
			if(_i == 2) then
			{
				_classname = selectRandom _fillerLoot;
			};
			_cargoType = _classname call ExileClient_util_cargo_getType;
			switch (_cargoType) do
			{
				case 1: 	
				{ 
					_lootHolder addMagazineCargoGlobal [_classname, 1]; 
				};
				case 2: 	
				{ 
					_lootHolder addWeaponCargoGlobal [_classname, 1]; 
					if !(_classname isKindOf ["Exile_Melee_Abstract", configFile >> "CfgWeapons"]) then
					{
						_magazineClassNames = getArray(configFile >> "CfgWeapons" >> _classname >> "magazines");
						if (count(_magazineClassNames) > 0) then
						{
							_magazineClassName = selectRandom _magazineClassNames;
							_numberOfMagazines = 2 + floor(random 3); 
							_lootHolder addMagazineCargoGlobal [_magazineClassName, _numberOfMagazines];
						};
					};
				};
				case 3: 	
				{ 
					_lootHolder addBackpackCargoGlobal [_classname, 1]; 
				};
				default
				{ 
					_lootHolder addItemCargoGlobal [_classname, 1]; 
				};
			};
		};
		
		if (_logging == 1) then
		{
			diag_log format["ExileServer_system_helicrash_spawnLoot: %1 spawned at %2", _classname, _lootPosition];
		};

		if (_markers == 1) then
		{
			_markPos = _lootPosition vectorAdd [0,0,1];
			_mark = createVehicle ["Sign_Sphere25cm_F", _markPos, [], 0, "CAN_COLLIDE"];
			_mark setDir (random 360);
			_mark setPosATL _markPos;
		};
	};
}
catch
{
	format ["ExileServer_system_helicrash_spawnLoot: %1", _exception] call ExileServer_util_log;
};