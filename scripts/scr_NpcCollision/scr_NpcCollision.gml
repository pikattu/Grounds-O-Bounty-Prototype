#macro NAV_NPC pNpcs
#macro NAV_NPC_SPACE 12

function nav_tile_solid(_x, _y) {
    var _tm = global.nav_tilemap;
    if (_tm == -1) return false;
    return (tilemap_get_at_pixel(_tm, _x, _y) != 0);
}

function nav_box_blocked(_x, _y) {
    var _l = _x + (bbox_left - x);
    var _r = _x + (bbox_right - x) - 1;
    var _t = _y + (bbox_top - y);
    var _b = _y + (bbox_bottom - y) - 1;
    var _mx = (_l + _r) * 0.5;
    var _my = (_t + _b) * 0.5;

    return nav_tile_solid(_l, _t)  || nav_tile_solid(_r, _t)
        || nav_tile_solid(_l, _b)  || nav_tile_solid(_r, _b)
        || nav_tile_solid(_mx, _t) || nav_tile_solid(_mx, _b)
        || nav_tile_solid(_l, _my) || nav_tile_solid(_r, _my);
}

function nav_line_blocked(_x1, _y1, _x2, _y2) {
    var _steps = max(1, ceil(point_distance(_x1, _y1, _x2, _y2) / 4));
    for (var i = 0; i <= _steps; i++) {
        var _f = i / _steps;
        if (nav_tile_solid(lerp(_x1, _x2, _f), lerp(_y1, _y2, _f))) return true;
    }
    return false;
}


function npc_move_collide(_dx, _dy) {
    var _ox = x;
    var _oy = y;

    if (!npc_blocked(x + _dx, y)) x += _dx;
    if (!npc_blocked(x, y + _dy)) y += _dy;

    return (x != _ox || y != _oy);
}

function nav_find_collision_tilemap() {
    var _layers = layer_get_all();
    for (var i = 0; i < array_length(_layers); i++) {
        var _els = layer_get_all_elements(_layers[i]);
        for (var j = 0; j < array_length(_els); j++) {
            if (layer_get_element_type(_els[j]) == layerelementtype_tilemap) {
                if (tilemap_get_tileset(_els[j]) == tCollision) return _els[j];
            }
        }
    }
    return -1;
}

function npc_near_other(_range) {
    var _list = global.npc_list;
    for (var i = 0; i < array_length(_list); i++) {
        var _o = _list[i];
        if (_o == id || !instance_exists(_o)) continue;
        if (point_distance(x, y, _o.x, _o.y) < _range) return true;
    }
    return false;
}

function npc_blocked(_x, _y) {
    if (nav_box_blocked(_x, _y)) return true;

    if (nav_ghost) return false;

    var _list = global.npc_list;
    for (var i = 0; i < array_length(_list); i++) {
        var _o = _list[i];
        if (_o == id || !instance_exists(_o)) continue;

        var _now  = point_distance(x, y, _o.x, _o.y);
        var _next = point_distance(_x, _y, _o.x, _o.y);
        if (_next < NAV_NPC_SPACE && _next < _now) return true;
    }
    return false;
}

function npc_separate(_space = 10, _push = 1) {
    if (nav_ghost) exit;	

    var _list = global.npc_list;
    for (var i = 0; i < array_length(_list); i++) {
        var _o = _list[i];
        if (_o == id || !instance_exists(_o)) continue;

        var _d = point_distance(x, y, _o.x, _o.y);
        if (_d >= _space) continue;

        var _dir = 0;
        if (_d < 0.01) {
            _dir = (id * 47) mod 360;
        } else {
            _dir = point_direction(_o.x, _o.y, x, y);
        }
        npc_move_collide(lengthdir_x(_push, _dir), lengthdir_y(_push, _dir));
    }
}

function nav_random_spot(_cx, _cy, _radius) {
    for (var i = 0; i < 15; i++) {
        var _a = random(360);
        var _r = sqrt(random(1)) * _radius;
        var _px = _cx + lengthdir_x(_r, _a);
        var _py = _cy + lengthdir_y(_r, _a);

        if (nav_box_blocked(_px, _py)) continue;
        if (nav_line_blocked(_cx, _cy, _px, _py)) continue;

        var _taken = false;
        var _list = global.npc_list;
        for (var j = 0; j < array_length(_list); j++) {
            var _o = _list[j];
            if (_o == id || !instance_exists(_o)) continue;
            if (point_distance(_px, _py, _o.x, _o.y) < NAV_NPC_SPACE) { _taken = true; break; }
        }
        if (_taken) continue;

        return { x: _px, y: _py };
    }
    return { x: _cx, y: _cy };
}