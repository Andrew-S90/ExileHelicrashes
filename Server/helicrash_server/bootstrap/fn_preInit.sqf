 /*
 *
 * Author: Andrew_S90
 *
 * This work is protected by Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0). 
 *
 */
 
private ['_code', '_function', '_file', '_fileContent'];

{
    _code = '';
    _function = _x select 0;
    _file = _x select 1;

    _fileContent = preprocessFileLineNumbers _file;

    _code = compileFinal _fileContent;                    

    missionNamespace setVariable [_function, _code];
}
forEach 
[
	['ExileServer_system_helicrash_spawnCrashes', 'helicrash_server\code\ExileServer_system_helicrash_spawnCrashes.sqf'],
	['ExileServer_system_helicrash_spawnLoot', 'helicrash_server\code\ExileServer_system_helicrash_spawnLoot.sqf']
];

diag_log "HELICRASH SERVER - Loaded.";

true