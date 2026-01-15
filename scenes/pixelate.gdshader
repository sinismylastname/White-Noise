shader_type canvas_item;

// 1. Tell Godot to grab the screen buffer
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform int amount = 40;

void fragment()
{
    // 2. Use SCREEN_UV instead of UV
    vec2 grid_uv = round(SCREEN_UV * float(amount)) / float(amount);
    
    // 3. Use the screen_texture sampler
    vec4 text = texture(screen_texture, grid_uv);
    
    COLOR = text;
}