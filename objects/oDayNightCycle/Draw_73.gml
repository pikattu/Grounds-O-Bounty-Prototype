
// ==========================================
// HANDLES TIME
// ==========================================

Time += global.DT;

TimeOfDay = sin(Time * DayNightSpeed);
TimeOfDay = clamp(TimeOfDay, 0, 0.8);

// ==========================================
// TORCH SPRITE SWITCH
// ==========================================

if (TimeOfDay > 0.3) {
    with (oTorch) {
        sprite_index = sTorchOn;
    }
}
else {
    with (oTorch) {
        sprite_index = sTorchOff;
    }
}

// ==========================================
// LIGHTING SURFACE
// ==========================================

if (!surface_exists(LightingSurface)) {
    LightingSurface = surface_create(room_width, room_height);
}

surface_set_target(LightingSurface);

gpu_set_blendmode(bm_normal);

// Draw night over screen
draw_clear_alpha(c_black, TimeOfDay);

// ==========================================
// TORCH LIGHTING EFFECT
// ==========================================

if (TimeOfDay > 0.3) {

    with (oTorch) {

        var SizeOff = random_range(-0.01, 0.01);

        gpu_set_blendmode(bm_subtract);

        draw_sprite_ext(
            sLightCutout, 0,
            x, y - 16,
            0.3 + SizeOff, 0.3 + SizeOff,
            0, c_white, 1
        );

        gpu_set_blendmode(bm_add);

        draw_sprite_ext(
            sLightCutout, 0,
            x, y - 16,
            0.3 + SizeOff, 0.3 + SizeOff,
            0, c_red, 0.5
        );

        gpu_set_blendmode(bm_normal);
    }
}

// ==========================================
// DISPLAY LIGHTING
// ==========================================

surface_reset_target();

draw_surface(LightingSurface, 0, 0);
