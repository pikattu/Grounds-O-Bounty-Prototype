enum NPC_STATE {
    WAITING,
    MOVING
}

function PathGraph() constructor {
    nodes = [];
    adj = [];
    name_lookup = {};

    static AddNode = function(_x, _y, _name, _roles, _radius) {
        var _i = array_length(nodes);
        array_push(nodes, { x: _x, y: _y, name: _name, roles: _roles, radius: _radius });
        array_push(adj, []);
        name_lookup[$ _name] = _i;
        return _i;
    }

    static AddEdge = function(_a, _b) {
        var _cost = point_distance(nodes[_a].x, nodes[_a].y, nodes[_b].x, nodes[_b].y);
        array_push(adj[_a], { to: _b, cost: _cost });
        array_push(adj[_b], { to: _a, cost: _cost });
    }

    static GetZone = function(_name) {
        return variable_struct_exists(name_lookup, _name) ? name_lookup[$ _name] : -1;
    }

    static NodeAllowed = function(_i, _role) {
        var _roles = nodes[_i].roles;
        if (array_length(_roles) == 0) return true;
        return array_contains(_roles, _role);
    }

    static Nearest = function(_x, _y, _role) {
        var _best = -1, _bestd = infinity;
        for (var i = 0; i < array_length(nodes); i++) {
            if (!NodeAllowed(i, _role)) continue;
            var _d = point_distance(_x, _y, nodes[i].x, nodes[i].y);
            if (_d < _bestd) { _bestd = _d; _best = i; }
        }
        return _best;
    }

    static FindPath = function(_from, _to, _role) {
        var _n = array_length(nodes);
        if (_from < 0 || _to < 0) return [];
        if (!NodeAllowed(_to, _role)) return [];

        var _dist = array_create(_n, infinity);
        var _prev = array_create(_n, -1);
        var _done = array_create(_n, false);
        var _pq = ds_priority_create();

        _dist[_from] = 0;
        ds_priority_add(_pq, _from, 0);

        while (!ds_priority_empty(_pq)) {
            var _u = ds_priority_delete_min(_pq);
            if (_done[_u]) continue;
            _done[_u] = true;
            if (_u == _to) break;

            var _edges = adj[_u];
            for (var i = 0; i < array_length(_edges); i++) {
                var _e = _edges[i];
                if (!NodeAllowed(_e.to, _role)) continue;
                var _alt = _dist[_u] + _e.cost;
                if (_alt < _dist[_e.to]) {
                    _dist[_e.to] = _alt;
                    _prev[_e.to] = _u;
                    ds_priority_add(_pq, _e.to, _alt);
                }
            }
        }
        ds_priority_destroy(_pq);

        if (_dist[_to] == infinity) return [];

        var _path = [];
        var _c = _to;
        while (_c != -1) {
            array_insert(_path, 0, _c);
            _c = _prev[_c];
        }
        return _path;
    }
}

function scr_build_path_graph(_max_link = 200) {
    global.nav_tilemap = nav_find_collision_tilemap();
    global.npc_list = [];

    var _g = new PathGraph();

    with (obj_location_) {
        if (!variable_instance_exists(id, "allowed_roles")) allowed_roles = [];
        if (!variable_instance_exists(id, "zone_radius")) {
            zone_radius = (object_index == obj_location_) ? 0 : 32;
        }
        node_index = _g.AddNode(x, y, object_get_name(object_index), allowed_roles, zone_radius);
    }

    var _n = array_length(_g.nodes);
    for (var i = 0; i < _n; i++) {
        for (var j = i + 1; j < _n; j++) {
            var _a = _g.nodes[i], _b = _g.nodes[j];
            if (point_distance(_a.x, _a.y, _b.x, _b.y) > _max_link) continue;
            if (nav_line_blocked(_a.x, _a.y, _b.x, _b.y)) continue;
            _g.AddEdge(i, j);
        }
    }

    global.path_graph = _g;
    return _g;
}

function npc_nav_step() {
    if (!variable_global_exists("path_graph")) exit;
    var _g = global.path_graph;
    var _fps = game_get_speed(gamespeed_fps);

    if (!variable_instance_exists(id, "nav_ready")) {
        nav_ready = true;
        nav_path = [];
        nav_step = 0;
        nav_stuck = 0;
        nav_ghost = false;
        nav_ghost_timer = 0;
        nav_spot_x = x;
        nav_spot_y = y;
        wander_pause = irandom_range(2, 5) * _fps;
        if (!variable_instance_exists(id, "zone_mode")) zone_mode = "random";
        nav_node = _g.Nearest(x, y, role);
        state = "waiting";
        wait_timer = wait_duration * _fps;
    }

    if (!variable_global_exists("npc_list")) global.npc_list = [];
    if (!array_contains(global.npc_list, id)) array_push(global.npc_list, id);

    if (nav_node < 0) {
        nav_node = _g.Nearest(x, y, role);
        if (nav_node < 0) exit;
    }

    npc_separate();

    if (state == "waiting") {
        wait_timer -= 1;

        if (wait_timer > 0) {
            if (zone_mode == "wander" && _g.nodes[nav_node].radius > 0) {
                wander_pause -= 1;
                if (wander_pause <= 0) {
                    var _wn = _g.nodes[nav_node];
                    var _ws = nav_random_spot(_wn.x, _wn.y, _wn.radius);
                    nav_spot_x = _ws.x;
                    nav_spot_y = _ws.y;
                    nav_stuck = 0;
                    state = "wandering";
                }
            }
            exit;
        }

        var _count = array_length(my_zones);
        for (var i = 0; i < _count; i++) {
            var _dest = _g.GetZone(object_get_name(my_zones[current_zone_index]));
            current_zone_index = (current_zone_index + 1) mod _count;

            var _p = _g.FindPath(nav_node, _dest, role);
            if (array_length(_p) > 1) {
                nav_path = _p;
                nav_step = 0;
                nav_stuck = 0;
                nav_ghost = false;
                state = "moving";
                break;
            }
        }

        if (state != "moving") wait_timer = wait_duration * _fps;
    }
    else if (state == "moving") {
        if (nav_ghost) {
            nav_ghost_timer -= 1;
            if (!npc_near_other(NAV_NPC_SPACE * 1.5) || nav_ghost_timer <= 0) nav_ghost = false;
        }

        var _t = _g.nodes[nav_path[nav_step]];
        var _is_last = (nav_step == array_length(nav_path) - 1);
        var _d = point_distance(x, y, _t.x, _t.y);

        var _arrive = max(move_speed, 3);
        if (_is_last) _arrive = 6;

        var _crowded = (nav_stuck > 20 && _d < 24);

        if (_d <= _arrive || _crowded) {
            nav_node = nav_path[nav_step];
            nav_step++;
            nav_stuck = 0;

            if (nav_step >= array_length(nav_path)) {
                var _an = _g.nodes[nav_node];
                if (zone_mode != "exact" && _an.radius > 0) {
                    var _as = nav_random_spot(_an.x, _an.y, _an.radius);
                    nav_spot_x = _as.x;
                    nav_spot_y = _as.y;
                    state = "settling";
                } else {
                    state = "waiting";
                    wait_timer = wait_duration * _fps;
                    wander_pause = irandom_range(2, 5) * _fps;
                }
            }
            exit;
        }

        var _dir = point_direction(x, y, _t.x, _t.y);
        var _moved = npc_move_collide(lengthdir_x(move_speed, _dir), lengthdir_y(move_speed, _dir));

        if (_moved) {
            nav_stuck = 0;
        } else {
            nav_stuck += 1;
        }

        if (nav_stuck >= 2 * _fps) {
            nav_stuck = 0;

            if (npc_near_other(NAV_NPC_SPACE * 1.5)) {
                nav_ghost = true;
                nav_ghost_timer = 4 * _fps;
            } else {
                nav_node = _g.Nearest(x, y, role);
                var _n = array_length(my_zones);
                current_zone_index = (current_zone_index - 1 + _n) mod _n;
                state = "waiting";
                wait_timer = 2 * _fps;
            }
        }
    }
    else if (state == "settling" || state == "wandering") {
        if (state == "wandering") {
            wait_timer -= 1;
            if (wait_timer <= 0) {
                state = "waiting";
                exit;
            }
        }

        var _sd = point_distance(x, y, nav_spot_x, nav_spot_y);

        if (_sd <= 3 || nav_stuck >= _fps) {
            if (state == "settling") wait_timer = wait_duration * _fps;
            state = "waiting";
            nav_stuck = 0;
            wander_pause = irandom_range(2, 5) * _fps;
            exit;
        }

        var _sdir = point_direction(x, y, nav_spot_x, nav_spot_y);
        var _smoved = npc_move_collide(lengthdir_x(move_speed, _sdir), lengthdir_y(move_speed, _sdir));

        if (_smoved) {
            nav_stuck = 0;
        } else {
            nav_stuck += 1;
        }
    }
}