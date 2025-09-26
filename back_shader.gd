@tool
extends ColorRect

@export var speed : float = 0.1;
@export var shader : ShaderMaterial;

var control_pos : float = 0.0;

func _process(delta: float) -> void:
	if(shader):
		control_pos += speed * delta;
		if(control_pos > 1.0):
			control_pos = 0.0;
		if(control_pos < 0.0):
			control_pos = 1.0;
		shader.set_shader_parameter("speed", control_pos);
