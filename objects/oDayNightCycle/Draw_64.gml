if (surface_exists(application_surface)) {

    shader_set(shNightTint);

    shader_set_uniform_f(uNight, NightSmooth);

    draw_surface_stretched(
        application_surface,
        0, 0,
        display_get_gui_width(),
        display_get_gui_height()
    );

    shader_reset();
}