#macro SAVE_FILE     "savegame.js"
#macro SAVE_BACKUP   "savegame_backup.js"
#macro SAVE_VERSION  1

function save_ensure_init() {
    if (variable_global_exists("save_init")) return;
    global.save_init = true;
    global.save_rooms = {};          
    global.save_pending = undefined;  
	
	
	//f6 load items, f5 save, f9 load save
    global.save_vars = {
        oPlayer:         [],   // e.g. ["money", "stamina"]
        oTimeOfDay:      [],   // e.g. ["hour", "minute"]
        oDayNightCycle:  [],   // e.g. ["day"]
        oPlot:           [],   // e.g. ["crop", "stage", "watered"]
        oChest:          []    // e.g. ["contents"]
    };
}

function save_singleton_list() { return [oPlayer, oTimeOfDay, oDayNightCycle]; }

function save_room_objects() { return [oPlot, oChest]; }

function save_collect_globals() {
    return {
        money: global.money,
        inventory: global.inventory
    };
}
function save_apply_globals(_g) {
     if (variable_struct_exists(_g, "money")) global.money = _g.money;
    if (variable_struct_exists(_g, "inventory")) global.inventory = _g.inventory;
}

function save_capture_instance(_inst, _obj) {
    var _names = global.save_vars[$ object_get_name(_obj)];
    var _entry = { x: _inst.x, y: _inst.y, vars: {} };
    if (_names != undefined) {
        for (var i = 0; i < array_length(_names); i++) {
            var _n = _names[i];
            if (variable_instance_exists(_inst, _n)) {
                _entry.vars[$ _n] = variable_instance_get(_inst, _n);
            }
        }
    }
    return _entry;
}

function save_apply_instance(_inst, _entry) {
    var _keys = variable_struct_get_names(_entry.vars);
    for (var i = 0; i < array_length(_keys); i++) {
        variable_instance_set(_inst, _keys[i], _entry.vars[$ _keys[i]]);
    }
}

function save_capture_objects(_obj) {
    var _list = [];
    with (_obj) {
        array_push(_list, save_capture_instance(id, _obj));
    }
    return _list;
}

function save_apply_objects(_obj, _list) {
    for (var i = 0; i < array_length(_list); i++) {
        var _e = _list[i];
        with (_obj) {
            if (x == _e.x && y == _e.y) save_apply_instance(id, _e);
        }
    }
}

function save_collect_singletons() {
    var _out = {};
    var _list = save_singleton_list();
    for (var i = 0; i < array_length(_list); i++) {
        var _o = _list[i];
        if (!instance_exists(_o)) continue;
        _out[$ object_get_name(_o)] = save_capture_instance(instance_find(_o, 0), _o);
    }
    return _out;
}

function save_apply_singletons(_s) {
    var _list = save_singleton_list();
    for (var i = 0; i < array_length(_list); i++) {
        var _o = _list[i];
        var _name = object_get_name(_o);
        if (!variable_struct_exists(_s, _name) || !instance_exists(_o)) continue;

        var _inst = instance_find(_o, 0);
        var _entry = _s[$ _name];
        save_apply_instance(_inst, _entry);
        if (_o == oPlayer) {
            _inst.x = _entry.x;
            _inst.y = _entry.y;
        }
    }
}

// ---------------------------------------------------------------------------
// per-room state (plots, chests)
// A room's instances only exist while you're in it, so state is captured when
// you leave a room (see oTp below) and when you save.
// ---------------------------------------------------------------------------
function save_capture_room() {
    save_ensure_init();
    var _st = {};
    var _objs = save_room_objects();
    for (var i = 0; i < array_length(_objs); i++) {
        var _names = global.save_vars[$ object_get_name(_objs[i])];
        if (_names == undefined || array_length(_names) == 0) continue;
        _st[$ object_get_name(_objs[i])] = save_capture_objects(_objs[i]);
    }
    global.save_rooms[$ room_get_name(room)] = _st;
}

function save_apply_room() {
    var _st = global.save_rooms[$ room_get_name(room)];
    if (_st == undefined) return;
    var _objs = save_room_objects();
    for (var i = 0; i < array_length(_objs); i++) {
        var _name = object_get_name(_objs[i]);
        if (variable_struct_exists(_st, _name)) save_apply_objects(_objs[i], _st[$ _name]);
    }
}

// ---------------------------------------------------------------------------
// file helpers
// ---------------------------------------------------------------------------
function save_write_text(_file, _text) {
    var _buf = buffer_create(string_byte_length(_text) + 1, buffer_fixed, 1);
    buffer_write(_buf, buffer_string, _text);
    buffer_save(_buf, _file);
    buffer_delete(_buf);
}

function save_try_read(_file) {
    if (!file_exists(_file)) return undefined;
    var _buf = buffer_load(_file);
    var _text = buffer_read(_buf, buffer_string);
    buffer_delete(_buf);

    var _d = undefined;
    try {
        _d = json_parse(_text);
    } catch (_e) {
        return undefined;
    }
    if (!is_struct(_d)) return undefined;
    if (!variable_struct_exists(_d, "version") || !variable_struct_exists(_d, "room")) return undefined;
    return _d;
}

// ---------------------------------------------------------------------------
// the functions you call
// ---------------------------------------------------------------------------
function save_data_exists() {
    return file_exists(SAVE_FILE) || file_exists(SAVE_BACKUP);
}

function save_game() {
    save_ensure_init();
    antique_ensure_init();
    save_capture_room();

    var _data = {
        version: SAVE_VERSION,
        room: room_get_name(room),
        globals: save_collect_globals(),
        singletons: save_collect_singletons(),
        rooms: global.save_rooms,
        antiques: antique_get_save_data()
    };

    // keep the previous save as a backup
    if (file_exists(SAVE_FILE)) {
        if (file_exists(SAVE_BACKUP)) file_delete(SAVE_BACKUP);
        file_copy(SAVE_FILE, SAVE_BACKUP);
    }

    save_write_text(SAVE_FILE, json_stringify(_data, true));
    show_debug_message("Game saved to: " + game_save_id + SAVE_FILE);
}

// Reads the save, changes to the saved room, and applies everything once that room starts.
function load_game() {
    save_ensure_init();

    var _d = save_try_read(SAVE_FILE);
    if (_d == undefined) _d = save_try_read(SAVE_BACKUP);
    if (_d == undefined) {
        show_debug_message("No readable save file found.");
        return false;
    }

    var _rm = asset_get_index(_d.room);
    if (_rm == -1 || !room_exists(_rm)) {
        show_debug_message("Saved room no longer exists: " + string(_d.room));
        return false;
    }

    global.save_rooms = _d.rooms;
    global.save_pending = _d;
    room_goto(_rm);
    return true;
}

// Runs every frame from oGameManager Step. Does nothing unless a load is waiting.
function save_apply_pending() {
    save_ensure_init();
    var _d = global.save_pending;
    if (_d == undefined) return;
    if (room_get_name(room) != _d.room) return;   // wait until the saved room is running
    global.save_pending = undefined;

    save_apply_globals(_d.globals);
    save_apply_singletons(_d.singletons);
    save_apply_room();

    antique_ensure_init();
    antique_apply_save_data(_d.antiques);
    with (oDigSpot) instance_destroy();
    global.antique_room = -1;      // oGameManager Step rebuilds the mounds
}

// For the New Game button.
function save_new_game() {
    save_ensure_init();
    if (file_exists(SAVE_FILE)) file_delete(SAVE_FILE);
    if (file_exists(SAVE_BACKUP)) file_delete(SAVE_BACKUP);
    global.save_rooms = {};
    global.save_pending = undefined;
    antique_reset_save();
}

// DEBUG: prints the variables of the first instance of an object.
function save_debug_print_vars(_obj) {
    if (!instance_exists(_obj)) {
        show_debug_message(object_get_name(_obj) + ": no instance in this room");
        return;
    }
    var _inst = instance_find(_obj, 0);
    var _names = variable_instance_get_names(_inst);
    var _s = object_get_name(_obj) + ": ";
    for (var i = 0; i < array_length(_names); i++) {
        var _v = variable_instance_get(_inst, _names[i]);
        var _t = typeof(_v);
        if (_t == "number" || _t == "string" || _t == "bool") {
            _s += _names[i] + "=" + string(_v) + ", ";
        } else {
            _s += _names[i] + "=<" + _t + ">, ";
        }
    }
    show_debug_message(_s);
}