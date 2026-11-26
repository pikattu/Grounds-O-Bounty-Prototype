#macro ANTIQUE_KEY             ord("E")
#macro ANTIQUE_DIG_RANGE       24
#macro ANTIQUE_SPOTS_PER_ROOM  6
#macro ANTIQUE_MIN_SPACING     48
#macro ANTIQUE_GRID            16

function antique_ensure_init() {
    if (variable_global_exists("antique_defs")) return;

    global.antique_defs = [
        { name: "Clay Jar Shard",        desc: "A piece of a very old clay jar.", weight: 40, sprite: "sAntique0" },
        { name: "Old Spanish Coin",      desc: "Worn smooth by time.",            weight: 30, sprite: "sAntique1" },
        { name: "Carved Stone Figurine", desc: "Who made this, and why?",         weight: 20, sprite: "sAntique2" },
        { name: "Rusted Bronze Bell",    desc: "It still rings, faintly.",        weight: 10, sprite: "sAntique3" }
    ];

    global.antique_dirt = [[195, 195]];
    global.antique_dirt_layers = ["tLand"];
    global.antique_rooms = ["rmVillage", "rmPlayerFarm"];

    global.antique_day = 0;
    global.antique_state = {};
    global.antique_found = [0, 0, 0, 0];
    global.antique_room = -1;
}

function antique_is_dirt(_x, _y) {
    var _ranges = global.antique_dirt;
    var _names = global.antique_dirt_layers;
    var _layers = layer_get_all();
    for (var i = 0; i < array_length(_layers); i++) {
        if (!array_contains(_names, layer_get_name(_layers[i]))) continue;

        var _els = layer_get_all_elements(_layers[i]);
        for (var j = 0; j < array_length(_els); j++) {
            if (layer_get_element_type(_els[j]) != layerelementtype_tilemap) continue;

            var _data = tilemap_get_at_pixel(_els[j], _x, _y);
            if (_data == 0) continue;
            var _idx = tile_get_index(_data);
            for (var k = 0; k < array_length(_ranges); k++) {
                if (_idx >= _ranges[k][0] && _idx <= _ranges[k][1]) return true;
            }
        }
    }
    return false;
}

function antique_spot_ok(_x, _y, _spots) {
    if (!antique_is_dirt(_x, _y)) return false;
    if (variable_global_exists("nav_tilemap") && nav_tile_solid(_x, _y)) return false;
    for (var i = 0; i < array_length(_spots); i++) {
        if (point_distance(_x, _y, _spots[i].x, _spots[i].y) < ANTIQUE_MIN_SPACING) return false;
    }
    return true;
}

function antique_roll() {
    var _defs = global.antique_defs;
    var _total = 0;
    for (var i = 0; i < array_length(_defs); i++) _total += _defs[i].weight;

    var _r = random(_total);
    for (var i = 0; i < array_length(_defs); i++) {
        _r -= _defs[i].weight;
        if (_r < 0) return i;
    }
    return 0;
}

function antique_generate_spots() {
    var _cells = [];
    var _ranges = global.antique_dirt;
    var _layers = layer_get_all();

    for (var i = 0; i < array_length(_layers); i++) {
        if (!array_contains(global.antique_dirt_layers, layer_get_name(_layers[i]))) continue;

        var _els = layer_get_all_elements(_layers[i]);
        for (var j = 0; j < array_length(_els); j++) {
            if (layer_get_element_type(_els[j]) != layerelementtype_tilemap) continue;

            var _tm = _els[j];
            var _tw = tilemap_get_tile_width(_tm);
            var _th = tilemap_get_tile_height(_tm);
            var _ox = tilemap_get_x(_tm);
            var _oy = tilemap_get_y(_tm);

            for (var cy = 0; cy < tilemap_get_height(_tm); cy++) {
                for (var cx = 0; cx < tilemap_get_width(_tm); cx++) {
                    var _data = tilemap_get(_tm, cx, cy);
                    if (_data == 0) continue;
                    var _idx = tile_get_index(_data);
                    for (var k = 0; k < array_length(_ranges); k++) {
                        if (_idx >= _ranges[k][0] && _idx <= _ranges[k][1]) {
                            array_push(_cells, [_ox + cx * _tw + _tw / 2, _oy + cy * _th + _th / 2]);
                            break;
                        }
                    }
                }
            }
        }
    }

    var _spots = [];
    var _tries = 0;
    while (array_length(_cells) > 0 && array_length(_spots) < ANTIQUE_SPOTS_PER_ROOM && _tries < 400) {
        _tries++;
        var _c = _cells[irandom(array_length(_cells) - 1)];

        if (variable_global_exists("nav_tilemap") && nav_tile_solid(_c[0], _c[1])) continue;

        var _far = true;
        for (var s = 0; s < array_length(_spots); s++) {
            if (point_distance(_c[0], _c[1], _spots[s].x, _spots[s].y) < ANTIQUE_MIN_SPACING) _far = false;
        }
        if (!_far) continue;

        array_push(_spots, { x: _c[0], y: _c[1], artifact: antique_roll(), dug: false });
    }

    show_debug_message("ANTIQUES: " + room_get_name(room) + " dirt cells: " + string(array_length(_cells))
        + " | spots: " + string(array_length(_spots)));
    return _spots;
}

function antique_setup_room() {
    antique_ensure_init();
    global.antique_room = room;
    if (!array_contains(global.antique_rooms, room_get_name(room))) return;

    var _key = room_get_name(room);
    var _st = global.antique_state[$ _key];
    if (_st == undefined || _st.day != global.antique_day) {
        _st = { day: global.antique_day, spots: antique_generate_spots() };
        global.antique_state[$ _key] = _st;
    }

    for (var i = 0; i < array_length(_st.spots); i++) {
        var _s = _st.spots[i];
        if (_s.dug) continue;
        instance_create_depth(_s.x, _s.y, -_s.y, oDigSpot, { spot: _s });
    }
}

function antique_new_day() {
    antique_ensure_init();
    global.antique_day += 1;
    with (oDigSpot) instance_destroy();
    antique_setup_room();
}

function antique_give_item(_a) {
    antique_ensure_init();
    global.antique_found[_a] += 1;
}

function antique_can_dig() {
    return !dialogue_is_active();
}

function antique_sprite(_a) {
    var _spr = asset_get_index(global.antique_defs[_a].sprite);
    return sprite_exists(_spr) ? _spr : -1;
}

function antique_get_save_data() {
    antique_ensure_init();
    return {
        version: 1,
        day: global.antique_day,
        found: global.antique_found,
        state: global.antique_state
    };
}

function antique_apply_save_data(_data) {
    if (!is_struct(_data)) return false;
    if (!variable_struct_exists(_data, "day")) return false;
    if (!variable_struct_exists(_data, "found")) return false;
    if (!variable_struct_exists(_data, "state")) return false;
    if (!is_array(_data.found) || array_length(_data.found) != 4) return false;

    global.antique_day = _data.day;
    global.antique_found = _data.found;
    global.antique_state = _data.state;
    return true;
}

function antique_reset_save() {
    antique_ensure_init();
    global.antique_day = 0;
    global.antique_found = [0, 0, 0, 0];
    global.antique_state = {};
    with (oDigSpot) instance_destroy();
    global.antique_room = -1;
}

function antique_debug_tile_under_mouse() {
    show_debug_message("--- tile debug at " + string(mouse_x) + "," + string(mouse_y) + " ---");
    var _found = 0;
    var _layers = layer_get_all();
    for (var i = 0; i < array_length(_layers); i++) {
        var _els = layer_get_all_elements(_layers[i]);
        for (var j = 0; j < array_length(_els); j++) {
            if (layer_get_element_type(_els[j]) != layerelementtype_tilemap) continue;
            _found++;

            var _data = tilemap_get_at_pixel(_els[j], mouse_x, mouse_y);
            var _idx = "empty";
            if (_data != 0) _idx = string(tile_get_index(_data));

            show_debug_message("layer '" + layer_get_name(_layers[i]) + "' | tileset: "
                + tileset_get_name(tilemap_get_tileset(_els[j])) + " | tile index: " + _idx);
        }
    }
    if (_found == 0) show_debug_message("no tilemap layers found in this room");
}

function antique_learn_dirt_tile() {
    antique_ensure_init();
    var _layers = layer_get_all();
    for (var i = 0; i < array_length(_layers); i++) {
        if (!array_contains(global.antique_dirt_layers, layer_get_name(_layers[i]))) continue;

        var _els = layer_get_all_elements(_layers[i]);
        for (var j = 0; j < array_length(_els); j++) {
            if (layer_get_element_type(_els[j]) != layerelementtype_tilemap) continue;

            var _data = tilemap_get_at_pixel(_els[j], mouse_x, mouse_y);
            if (_data == 0) continue;
            var _idx = tile_get_index(_data);

            var _have = false;
            for (var k = 0; k < array_length(global.antique_dirt); k++) {
                if (global.antique_dirt[k][0] == _idx) _have = true;
            }
            if (!_have) array_push(global.antique_dirt, [_idx, _idx]);
        }
    }

    var _s = "global.antique_dirt = [";
    for (var k = 0; k < array_length(global.antique_dirt); k++) {
        _s += "[" + string(global.antique_dirt[k][0]) + ", " + string(global.antique_dirt[k][1]) + "]";
        if (k < array_length(global.antique_dirt) - 1) _s += ", ";
    }
    _s += "];";
    show_debug_message(_s);
}