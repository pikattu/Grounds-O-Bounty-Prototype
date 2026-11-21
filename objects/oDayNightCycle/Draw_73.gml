
/// oDayNightCycle - Draw End Event

// ==========================================
// CREATE / RECREATE LIGHTING SURFACE
// ==========================================

if (!surface_exists(LightingSurface)
|| surface_get_width(LightingSurface) != room_width
|| surface_get_height(LightingSurface) != room_height)
{
    if (surface_exists(LightingSurface)) {
        surface_free(LightingSurface);
    }

    LightingSurface = surface_create(room_width, room_height);
}

// ==========================================
// DRAW LIGHTING
// ==========================================

if (surface_exists(LightingSurface)) {

    surface_set_target(LightingSurface);

    gpu_set_blendmode(bm_normal);

    // Dark overlay
    draw_clear_alpha(c_black, Darkness);

    // ==========================================
    // TORCH LIGHTING
    // ==========================================

    if (global.TorchOn) {

        with (oTorch) {

            var _sizeOffset = random_range(-0.01, 0.01);

            var _lightSize = 0.3 + _sizeOffset;

            // Remove darkness around torch
            gpu_set_blendmode(bm_subtract);

            draw_sprite_ext(
                sLightCutout, 0,
                x, y - 16,
                _lightSize, _lightSize,
                0, c_white, 1
            );

            // Warm torch glow
            gpu_set_blendmode(bm_add);

            draw_sprite_ext(
                sLightCutout, 0,
                x, y - 16,
                _lightSize, _lightSize,
                0, c_red, 0.5
            );

            gpu_set_blendmode(bm_normal);
        }
    }

    surface_reset_target();

    // ==========================================
    // DISPLAY LIGHTING
    // ==========================================

    gpu_set_blendmode(bm_normal);

    draw_surface(LightingSurface, 0, 0);
}
