
#macro DIALOGUE_KEY               ord("E")
#macro DIALOGUE_RANGE             28
#macro DIALOGUE_BOX_SPRITE        sTextBox
#macro DIALOGUE_BLOCK_ON_TEXTBOX  false


function dialogue_is_active() {
    return variable_global_exists("dialogue_active") && global.dialogue_active;
}

function dialogue_display_name(_role) {
    if (_role == "mj") return "MJ";
    return string_upper(string_char_at(_role, 1)) + string_delete(_role, 1, 1);
}

function dialogue_conversations(_role) {
    switch (_role) {
        case "eduardo":
            return [
                ["Oh hey! How's life out here treating you", "Hopes Karinderya is amazing, Their food is the best in the village."],
                ["Come to the church yard with me sometimes.", "It's peaceful there."]
            ];
        case "hope":
            return [
                ["Hello! If you ever feel hungry, Me and my Lola would be glad to feed you!", "Hm? Oh that's just a small knife accident I had."],
                ["Another school term is up... hays", "Those kids will be rowdy in the Karinderya again."]
            ];
        case "joshua":
            return [
                ["Hoy Ate! Wanna see my steps in court?"],
                ["Ma keeps teling me to be more careful but look at these marks!", "Okay! See you later Ate!"]
            ];
        case "kristine":
            return [
                ["Hmmmm? You're pretty Ate... but not like me!", "I have to show you my loom bands after classes!"],
                ["I heard inside your Lolo and Lola's shop is haunted.", "...Don't answer that."]
            ];
        case "mj":
            return [
                ["Wahoo!"],
                ["Oh hi Ate! Try to catch me!", "Aw alright, but keep an eye out Ate!"]
            ];
        case "princess":
            return [
                ["Oh? Hi there! Hope the others aren't bothering you.", "Hope you're enjoying San Dezaro."],
                ["Oooo I heard they're putting Joshua part of the church service next week", "We should see him stumble around!"]
            ];
    }
    return [["..."]];
}

function dialogue_ensure() {
    if (!instance_exists(oDialogue)) instance_create_depth(0, 0, -20000, oDialogue);
}

function dialogue_create() {
    global.dialogue_active = false;

    active = false;
    npc = noone;
    near_npc = noone;
    lines = [];
    line_i = 0;
    chars = 0;
    char_speed = 0.7;
    had_box = false;

    dialogue_font = -1;
    text_scale = 1;
}

function dialogue_step() {
	if (!variable_instance_exists(id, "lines")) dialogue_create();
    var _box = DIALOGUE_BLOCK_ON_TEXTBOX && instance_exists(oTextBox);
    var _was_box = had_box;
    had_box = _box;

    if (!active) {
        near_npc = noone;
        if (_box || _was_box) exit;

        var _list = [oEduardo, oHope, oJoshua, oKristine, oMJ, oPrincess];

        if (instance_exists(oPlayer)) {
            var _best = DIALOGUE_RANGE;
            for (var i = 0; i < array_length(_list); i++) {
                var _o = instance_nearest(oPlayer.x, oPlayer.y, _list[i]);
                if (_o == noone) continue;
                var _d = point_distance(oPlayer.x, oPlayer.y, _o.x, _o.y);
                if (_d < _best) {
                    _best = _d;
                    near_npc = _o;
                }
            }
        }

        if (near_npc != noone && keyboard_check_pressed(DIALOGUE_KEY)) {
            var _role = variable_instance_exists(near_npc, "role") ? near_npc.role : "";
            var _convos = dialogue_conversations(_role);

            if (!variable_instance_exists(near_npc, "talk_count")) near_npc.talk_count = 0;
            lines = _convos[near_npc.talk_count mod array_length(_convos)];
            near_npc.talk_count += 1;

            npc = near_npc;
            line_i = 0;
            chars = 0;
            active = true;
            global.dialogue_active = true;

            if (variable_instance_exists(npc, "state")) {
                npc.talk_prev_state = npc.state;
                npc.state = "talking";
            }
        }
        exit;
    }

    chars += char_speed;
    var _len = string_length(lines[line_i]);

    if (keyboard_check_pressed(DIALOGUE_KEY)) {
        if (chars < _len) {
            chars = _len;
        } else {
            line_i += 1;
            chars = 0;

            if (line_i >= array_length(lines)) {
                if (instance_exists(npc) && variable_instance_exists(npc, "talk_prev_state")) {
                    npc.state = npc.talk_prev_state;
                }
                active = false;
                npc = noone;
                global.dialogue_active = false;
            }
        }
    }
}

function dialogue_draw_gui() {
	if (!variable_instance_exists(id, "lines")) dialogue_create();
    var _gw = display_get_gui_width();
    var _gh = display_get_gui_height();

    if (dialogue_font != -1) draw_set_font(dialogue_font);

    if (!active && near_npc != noone && instance_exists(near_npc)) {
        var _cam = view_camera[0];
        var _px = (near_npc.x - camera_get_view_x(_cam)) * (_gw / camera_get_view_width(_cam));
        var _py = (near_npc.bbox_top - camera_get_view_y(_cam)) * (_gh / camera_get_view_height(_cam)) - 8;

        draw_set_halign(fa_center);
        draw_set_valign(fa_bottom);
        draw_set_color(c_black);
        draw_text_transformed(_px + 1, _py + 1, "[" + chr(DIALOGUE_KEY) + "]", text_scale, text_scale, 0);
        draw_set_color(c_white);
        draw_text_transformed(_px, _py, "[" + chr(DIALOGUE_KEY) + "]", text_scale, text_scale, 0);
    }

    if (active) {
        var _spr = DIALOGUE_BOX_SPRITE;
        var _bw = _gw * 0.8;
        var _bh = _gh * 0.25;
        var _bx = (_gw - _bw) / 2;
        var _by = _gh - _bh - _gh * 0.03;

        if (floor(chars) == 1) {
            show_debug_message("dlg box: gui " + string(_gw) + "x" + string(_gh)
                + " | sprite " + string(sprite_get_width(_spr)) + "x" + string(sprite_get_height(_spr)));
        }

        draw_set_alpha(0.9);
        draw_set_color(make_color_rgb(60, 40, 25));
        draw_rectangle(_bx, _by, _bx + _bw, _by + _bh, false);
        draw_set_alpha(1);

        if (sprite_exists(_spr)) draw_sprite_stretched(_spr, 0, _bx, _by, _bw, _bh);

        var _pad = _bw * 0.04;
        var _lh = string_height("A") * text_scale;
        var _role = variable_instance_exists(npc, "role") ? npc.role : "";
        var _name = dialogue_display_name(_role);
        var _shown = string_copy(lines[line_i], 1, floor(chars));
        var _tw = (_bw - _pad * 2) / text_scale;
        var _ny = _by + _pad * 0.6;
        var _ty = _ny + _lh + 6;

        draw_set_halign(fa_left);
        draw_set_valign(fa_top);

        draw_set_color(c_black);
        draw_text_transformed(_bx + _pad + 1, _ny + 1, _name, text_scale, text_scale, 0);
        draw_text_ext_transformed(_bx + _pad + 1, _ty + 1, _shown, -1, _tw, text_scale, text_scale, 0);

        draw_set_color(c_yellow);
        draw_text_transformed(_bx + _pad, _ny, _name, text_scale, text_scale, 0);
        draw_set_color(c_white);
        draw_text_ext_transformed(_bx + _pad, _ty, _shown, -1, _tw, text_scale, text_scale, 0);

        if (chars >= string_length(lines[line_i]) && ((current_time div 400) mod 2 == 0)) {
            draw_set_halign(fa_right);
            draw_set_valign(fa_bottom);
            draw_text_transformed(_bx + _bw - _pad, _by + _bh - _pad * 0.4, ">", text_scale, text_scale, 0);
        }
    }
}