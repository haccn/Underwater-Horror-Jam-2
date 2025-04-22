shader_type canvas_item;

uniform float outer_radius : hint_range(0.0, 5.0) = 1.5;
uniform vec4 vignette_color: source_color;

void fragment() {
	float x = abs(UV.x - 0.5) * 2.0;
	float y = abs(UV.y - 0.5) * 2.0;
	float v = sqrt((x * x) + (y * y)) / outer_radius;
	COLOR = vec4(COLOR.rgb, v * COLOR.a);
}
