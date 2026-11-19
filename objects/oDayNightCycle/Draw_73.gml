// ==========================================
// LIGHTING SURFACE
// ==========================================

// Check if surface needs to be recreated
if (!surface_exists(LightingSurface)
|| surface_get_width(LightingSurface) != room_width
|| surface_get_height(LightingSurface) != room_height) {

    // Free previous surface
    if (surface_exists(LightingSurface)) {
        surface_free(LightingSurface);
    }

    // Create surface matching current room
    LightingSurface = surface_create(room_width, room_height);
}

// ==========================================
// DRAW LIGHTING
// ==========================================

if (surface_exists(LightingSurface)) {

    surface_set_target(LightingSurface);

    gpu_set_blendmode(bm_normal);

    // Draw night darkness
    draw_clear_alpha(c_black, TimeOfDay);

    // ==========================================
    // TORCH LIGHTING EFFECT
    // ==========================================

    if (TimeOfDay > 0.3) {

        with (oTorch) {

            var _sizeOffset = random_range(-0.01, 0.01);

            gpu_set_blendmode(bm_subtract);

            draw_sprite_ext(
                sLightCutout, 0,
                x, y - 16,
                0.3 + _sizeOffset, 0.3 + _sizeOffset,
                0, c_white, 1
            );

            gpu_set_blendmode(bm_add);

            draw_sprite_ext(
                sLightCutout, 0,
                x, y - 16,
                0.3 + _sizeOffset, 0.3 + _sizeOffset,
                0, c_red, 0.5
            );

            gpu_set_blendmode(bm_normal);
        }
    }

    surface_reset_target();

    // Display lighting
    draw_surface(LightingSurface, 0, 0);
}
