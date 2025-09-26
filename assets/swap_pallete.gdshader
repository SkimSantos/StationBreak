shader_type canvas_item;

uniform int in_palette_colors = 10;
uniform sampler2D in_palette;
uniform sampler2D out_palette;

uniform float tolerance = 0.1;

vec3 color_swap(vec4 in_color, vec4 out_color) {
	return vec3(0.0);
}

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	int in_color_index = 0;
	float x_size = 1.0 / float(in_palette_colors);
	for(int i = 0; i < in_palette_colors; i++) {
		vec3 color_in = texture(in_palette, vec2(float(i) * x_size, 0.5)).rgb;
		if(color_in.r == color.r && color_in.g == color.g && color_in.b == color.b) {
			in_color_index = i;
		}
	}
	vec4 result_color = texture(out_palette, vec2(float(in_color_index) * x_size, 0.5));
	result_color.a = color.a;
	COLOR = result_color;
}
