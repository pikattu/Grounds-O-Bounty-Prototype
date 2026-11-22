if (variable_global_exists("nav_tilemap")) {
    draw_set_color(c_yellow);
    draw_text(mouse_x + 8, mouse_y - 12, string(nav_tile_solid(mouse_x, mouse_y)));
    draw_set_color(c_white);
}