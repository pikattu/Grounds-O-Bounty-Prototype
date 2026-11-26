#macro ENEMIES_ENABLED            true
#macro ENEMY_DEBUG                true
#macro ENEMY_IFRAME_SECONDS       5
#macro ENEMY_KNOCKBACK            16
#macro ENEMY_KNOCKBACK_FRAMES     8
#macro ENEMY_STUN_MS              150
#macro ENEMY_MAX_HITS             3
#macro ENEMY_REGEN_SECONDS        20
#macro ENEMY_FADE_SECONDS         1
#macro ENEMY_WARNING_SOUND        "sfxWarning"
#macro ENEMY_RESPAWN_ROOM         "rmPlayerFarm"
#macro ENEMY_RESPAWN_X            -1
#macro ENEMY_RESPAWN_Y            -1
#macro ENEMY_LOSE_SIGHT_SECONDS   1.5

function enemy_hits_init() {
    if (variable_global_exists("player_hits_left")) return;
    global.player_hits_left = ENEMY_MAX_HITS;
    global.enemy_last_hit_time = -999999999;
    global.player_dying = false;
}

function enemy_hits_left() {
    enemy_hits_init();
    if (global.player_hits_left < ENEMY_MAX_HITS && current_time - global.enemy_last_hit_time >= ENEMY_REGEN_SECONDS * 1000) {
        global.player_hits_left = ENEMY_MAX_HITS;
    }
    return global.player_hits_left;
}

function enemy_reset_player_hits() {
    enemy_hits_init();
    global.player_hits_left = ENEMY_MAX_HITS;
    global.enemy_last_hit_time = -999999999;
    global.player_dying = false;
}

function enemy_create() {
    if (!ENEMIES_ENABLED) {
        instance_destroy();
        exit;
    }

    radius = 6;
    max_hp = 3;
    hp = max_hp;
    move_speed = 1;
    sight_range = 90;
    lose_range = 150;
    attack_range = 18;
    attack_damage = 1;
    windup_time = 0.4;
    attack_cooldown = 1;
    wander_radius = 24;

    state = "idle";
    home_x = x;
    home_y = y;
    var _fps = game_get_speed(gamespeed_fps);
    idle_timer = irandom_range(1 * _fps, 3 * _fps);
    wander_x = x;
    wander_y = y;
    state_timer = 0;
    did_hit = false;
    chase_stuck = 0;
    sight_lost = 0;
    last_seen_x = x;
    last_seen_y = y;
    hit_flash = 0;
    kb_frames = 0;
    kb_dir = 0;
}

function enemy_wall_at(_x, _y) {
    if (!variable_global_exists("nav_tilemap")) return false;
    if (nav_tile_solid(_x, _y)) return true;
    for (var a = 0; a < 360; a += 45) {
        if (nav_tile_solid(_x + lengthdir_x(radius, a), _y + lengthdir_y(radius, a))) return true;
    }
    return false;
}

function enemy_crowded(_x, _y) {
    var _me = id;
    var _r = radius * 2;
    var _hit = false;
    with (oEnemy) {
        if (id == _me) continue;
        var _now = point_distance(_me.x, _me.y, x, y);
        var _next = point_distance(_x, _y, x, y);
        if (_next < _r && _next < _now) _hit = true;
    }
    return _hit;
}

function enemy_move(_dx, _dy) {
    var _ox = x;
    var _oy = y;
    if (!enemy_wall_at(x + _dx, y) && !enemy_crowded(x + _dx, y)) x += _dx;
    if (!enemy_wall_at(x, y + _dy) && !enemy_crowded(x, y + _dy)) y += _dy;
    return (x != _ox || y != _oy);
}

function enemy_can_see() {
    if (!instance_exists(oPlayer)) return false;
    if (!variable_global_exists("nav_tilemap")) return true;
    return !nav_line_blocked(x, y, oPlayer.x, oPlayer.y);
}

function enemy_player_invincible() {
    enemy_hits_init();
    if (global.player_dying) return true;
    return variable_global_exists("enemy_iframe_until") && current_time < global.enemy_iframe_until;
}

function enemy_player_stunned() {
    enemy_hits_init();
    if (global.player_dying) return true;
    return variable_global_exists("enemy_stun_until") && current_time < global.enemy_stun_until;
}

function enemy_play_warning() {
    var _snd = asset_get_index(ENEMY_WARNING_SOUND);
    if (!audio_exists(_snd)) _snd = asset_get_index("sfxInteraction");
    if (audio_exists(_snd)) audio_play_sound(_snd, 10, false);
}

function enemy_start_death() {
    global.player_dying = true;
    if (!instance_exists(oPlayerFade)) instance_create_depth(0, 0, -30000, oPlayerFade);
}

function enemy_damage_player(_amount) {
    enemy_hits_init();
    if (!instance_exists(oPlayer)) return false;
    if (enemy_player_invincible()) return false;

    if (antique_consume()) {
        show_debug_message("Antique used. Enemy removed.");
        instance_destroy();
        return false;
    }

    var _left = enemy_hits_left() - 1;
    global.player_hits_left = _left;
    global.enemy_last_hit_time = current_time;
    global.enemy_iframe_until = current_time + ENEMY_IFRAME_SECONDS * 1000;
    global.enemy_stun_until = current_time + ENEMY_STUN_MS;

    show_debug_message("Enemy hit the player. Hits left: " + string(_left));

    if (_left <= 0) {
        enemy_start_death();
        return false;
    }

    if (_left == 1) enemy_play_warning();
    return true;
}

function enemy_apply_knockback() {
    if (kb_frames <= 0) return;
    kb_frames -= 1;

    if (!instance_exists(oPlayer)) {
        kb_frames = 0;
        return;
    }

    var _step = ENEMY_KNOCKBACK / ENEMY_KNOCKBACK_FRAMES;
    var _dx = lengthdir_x(_step, kb_dir);
    var _dy = lengthdir_y(_step, kb_dir);
    var _check = variable_global_exists("nav_tilemap");

    with (oPlayer) {
        if (!_check || !nav_box_blocked(x + _dx, y)) x += _dx;
        if (!_check || !nav_box_blocked(x, y + _dy)) y += _dy;
    }
}

function enemy_take_damage(_amount) {
    hp -= _amount;
    hit_flash = 8;
    if (state == "idle") state = "chase";
    if (hp <= 0) instance_destroy();
}

function enemy_remove_all() {
    with (oEnemy) instance_destroy();
}

function enemy_step() {
    enemy_hits_init();
    if (global.player_dying) exit;
    if (variable_global_exists("dialogue_active") && global.dialogue_active) exit;

    enemy_apply_knockback();
    if (hit_flash > 0) hit_flash -= 1;

    var _fps = game_get_speed(gamespeed_fps);
    var _has_player = instance_exists(oPlayer);
    var _dist = 99999;
    if (_has_player) _dist = point_distance(x, y, oPlayer.x, oPlayer.y);

    switch (state) {
        case "idle":
            if (_has_player && _dist <= sight_range && enemy_can_see()) {
                state = "chase";
                chase_stuck = 0;
                sight_lost = 0;
                break;
            }

            idle_timer -= 1;
            if (idle_timer <= 0) {
                var _wa = random(360);
                var _wr = random(wander_radius);
                wander_x = home_x + lengthdir_x(_wr, _wa);
                wander_y = home_y + lengthdir_y(_wr, _wa);
                idle_timer = irandom_range(2 * _fps, 5 * _fps);
            }

            if (point_distance(x, y, wander_x, wander_y) > 2) {
                var _wd = point_direction(x, y, wander_x, wander_y);
                enemy_move(lengthdir_x(move_speed * 0.5, _wd), lengthdir_y(move_speed * 0.5, _wd));
            }
            break;

        case "chase":
            if (!_has_player) {
                state = "idle";
                wander_x = home_x;
                wander_y = home_y;
                idle_timer = _fps;
                sight_lost = 0;
                break;
            }

            var _sees = enemy_can_see();
            if (_sees) {
                last_seen_x = oPlayer.x;
                last_seen_y = oPlayer.y;
                sight_lost = 0;
            } else {
                sight_lost += 1;
            }

            if (_dist > lose_range || sight_lost > ENEMY_LOSE_SIGHT_SECONDS * _fps) {
                state = "idle";
                wander_x = home_x;
                wander_y = home_y;
                idle_timer = _fps;
                sight_lost = 0;
                break;
            }

            if (_dist <= attack_range && _sees) {
                state = "attack";
                state_timer = 0;
                did_hit = false;
                break;
            }

            var _tx = _sees ? oPlayer.x : last_seen_x;
            var _ty = _sees ? oPlayer.y : last_seen_y;

            if (point_distance(x, y, _tx, _ty) > 2) {
                var _cd = point_direction(x, y, _tx, _ty);
                if (enemy_move(lengthdir_x(move_speed, _cd), lengthdir_y(move_speed, _cd))) {
                    chase_stuck = 0;
                } else {
                    chase_stuck += 1;
                }
            }

            if (chase_stuck > 2 * _fps) {
                state = "idle";
                wander_x = home_x;
                wander_y = home_y;
                idle_timer = _fps;
                chase_stuck = 0;
                sight_lost = 0;
            }
            break;

        case "attack":
            state_timer += 1;
            var _windup = windup_time * _fps;

            if (state_timer >= _windup && !did_hit) {
                did_hit = true;
                if (_has_player && _dist <= attack_range * 1.3 && enemy_can_see()) {
                    if (enemy_damage_player(attack_damage)) {
                        kb_dir = point_direction(x, y, oPlayer.x, oPlayer.y);
                        kb_frames = ENEMY_KNOCKBACK_FRAMES;
                    }
                }
            }

            if (state_timer >= _windup + attack_cooldown * _fps) {
                if (_has_player && _dist <= lose_range) {
                    state = "chase";
                    chase_stuck = 0;
                    sight_lost = 0;
                } else {
                    state = "idle";
                }
            }
            break;
    }

    depth = -y;
}

function enemy_draw() {
    var _c = c_lime;
    if (state == "chase") _c = c_orange;
    if (state == "attack") _c = c_red;
    if (hit_flash > 0) _c = c_white;

    draw_set_color(c_black);
    draw_circle(x, y, radius + 1, false);
    draw_set_color(_c);
    draw_circle(x, y, radius, false);

    var _fps = game_get_speed(gamespeed_fps);
    if (state == "attack" && state_timer < windup_time * _fps) {
        draw_set_alpha(0.6);
        draw_set_color(c_red);
        draw_circle(x, y, attack_range * 1.3, true);
        draw_set_alpha(1);
        draw_set_halign(fa_center);
        draw_set_valign(fa_bottom);
        draw_text(x, y - radius - 4, "!");
    }

    if (hp < max_hp) {
        var _bw = 16;
        var _bx = x - _bw / 2;
        var _by = y - radius - 8;
        draw_set_color(c_black);
        draw_rectangle(_bx - 1, _by - 1, _bx + _bw + 1, _by + 3, false);
        draw_set_color(c_red);
        draw_rectangle(_bx, _by, _bx + _bw * (hp / max_hp), _by + 2, false);
    }

    if (ENEMY_DEBUG) {
        draw_set_alpha(0.25);
        draw_set_color(c_yellow);
        draw_circle(x, y, sight_range, true);
        draw_set_color(c_red);
        draw_circle(x, y, attack_range, true);
        draw_set_alpha(1);
    }

    draw_set_color(c_white);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}

function fade_create() {
    persistent = true;
    phase = 0;
    alpha = 0;
    timer = 0;
    wait_frames = 0;
    px = 0;
    py = 0;
    if (instance_exists(oPlayer)) {
        px = oPlayer.x;
        py = oPlayer.y;
    }
    target_room = asset_get_index(ENEMY_RESPAWN_ROOM);
}

function fade_step() {
    var _fps = game_get_speed(gamespeed_fps);

    if (phase <= 1 && instance_exists(oPlayer)) {
        oPlayer.x = px;
        oPlayer.y = py;
    }

    switch (phase) {
        case 0:
            alpha += 1 / (ENEMY_FADE_SECONDS * _fps);
            if (alpha >= 1) {
                alpha = 1;
                phase = 1;
                timer = 0.5 * _fps;
            }
            break;

        case 1:
            timer -= 1;
            if (timer <= 0) {
                if (room_exists(target_room) && room != target_room) room_goto(target_room);
                phase = 2;
                wait_frames = 0;
            }
            break;

        case 2:
            wait_frames += 1;
            var _arrived = (!room_exists(target_room) || room == target_room);
            if ((_arrived && instance_exists(oPlayer)) || wait_frames > 5 * _fps) {
                if (instance_exists(oPlayer)) {
                    var _rx = ENEMY_RESPAWN_X;
                    var _ry = ENEMY_RESPAWN_Y;
                    if (instance_exists(oHousePlayer)) {
                        _rx = (oHousePlayer.bbox_left + oHousePlayer.bbox_right) / 2;
                        _ry = oHousePlayer.bbox_bottom + 12;
                    }
                    if (_rx >= 0 && _ry >= 0) {
                        oPlayer.x = _rx;
                        oPlayer.y = _ry;
                    }
                    show_debug_message("Respawned at " + string(oPlayer.x) + "," + string(oPlayer.y));
                }
                global.player_hits_left = ENEMY_MAX_HITS;
                global.enemy_last_hit_time = -999999999;
                global.enemy_iframe_until = current_time + 3000;
                phase = 3;
            }
            break;

        case 3:
            alpha -= 1 / (ENEMY_FADE_SECONDS * _fps);
            if (alpha <= 0) {
                alpha = 0;
                global.player_dying = false;
                instance_destroy();
            }
            break;
    }
}

function fade_draw_gui() {
    if (alpha <= 0) exit;
    draw_set_alpha(alpha);
    draw_set_color(c_black);
    draw_rectangle(-5000, -5000, 10000, 10000, false);
    draw_set_alpha(1);
    draw_set_color(c_white);
}