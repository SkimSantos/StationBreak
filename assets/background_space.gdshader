shader_type canvas_item;

uniform vec4 color_1 : source_color;
uniform vec4 color_2 : source_color;
uniform vec4 color_3 : source_color;

uniform sampler2D NOISE_PATTERN;
uniform float noise_scale = 10.0;

uniform vec2 pixelate = vec2(160.0, 90.0);
uniform float speed  : hint_range(0.0, 1.0, 0.01) = 0.00;

const mat4 THRESHOLD_MATRIX = mat4(
		vec4(1.0 / 17.0,  9.0 / 17.0,  3.0 / 17.0, 11.0 / 17.0),
		vec4(13.0 / 17.0,  5.0 / 17.0, 15.0 / 17.0,  7.0 / 17.0),
		vec4(4.0 / 17.0, 12.0 / 17.0,  2.0 / 17.0, 10.0 / 17.0),
		vec4(16.0 / 17.0,  8.0 / 17.0, 14.0 / 17.0,  6.0 / 17.0));

vec3 dithering(vec3 color, vec2 uv, vec3 color_a, vec3 color_b){
	float bayer_index = THRESHOLD_MATRIX[int(uv.x) % 4][int(uv.y)% 4];
	if (bayer_index < color.r){
		color = color_a;
	} else{
		color = color_b;
	}
	return color;
}

void fragment() {
	vec2 uv = UV / noise_scale;
	uv.y += (speed);
	while(uv.y > 1.0) {
		uv.y -= 1.0;
	}
	vec2 pixel_scaled = pixelate * noise_scale;
	uv = round(uv * pixel_scaled) / pixel_scaled;
	vec3 noise_color = texture(NOISE_PATTERN, uv).rgb;
	ivec2 uv_pixel = ivec2(round(uv * pixel_scaled));
	float blend_base = 1.0 / 12.0;

	if(noise_color.r <= blend_base * 7.0) {
		COLOR = color_1;
	} else if(noise_color.r <= blend_base * 8.0) {
		if((uv_pixel.x % 2) == 0) {
			if((uv_pixel.y % 2) == 0) {
				COLOR = color_2;
			} else {
				COLOR = color_1;
			}
		} else {
			if((uv_pixel.x % 3) == 0) {
				if((uv_pixel.y % 3) == 0) {
					COLOR = color_2;
				} else {
					COLOR = color_1;
				}
			} else {
				COLOR = color_1;
			}
		}
	} else if(noise_color.r <= blend_base * 10.0) {
		if((uv_pixel.x % 2) == 0) {
			if((uv_pixel.y % 2) == 1) {
				COLOR = color_2;
			} else {
				COLOR = color_1;
			}
		} else {
			if((uv_pixel.y % 2) == 0) {
				COLOR = color_2;
			} else {
				COLOR = color_1;
			}
		}
	} else if(noise_color.r <= blend_base * 11.0) {
		if((uv_pixel.x % 2) == 0) {
			if((uv_pixel.y % 2) == 0) {
				COLOR = color_1;
			} else {
				COLOR = color_2;
			}
		} else {
			if((uv_pixel.x % 3) == 0) {
				if((uv_pixel.y % 3) == 0) {
					COLOR = color_1;
				} else {
					COLOR = color_2;
				}
			} else {
				COLOR = color_2;
			}
		}
	} else {
		COLOR = color_2;
	}
}

