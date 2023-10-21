shader_type canvas_item;

uniform float fade_progress : hint_range(0, 1);

void fragment() {
    //COLOR = texture(TEXTURE, SCREEN_UV);
    COLOR.a *= fade_progress; // Adjust alpha based on fade progress
}
