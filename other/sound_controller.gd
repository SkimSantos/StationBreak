extends Node
class_name SoundControl

@export var music_control : Node = null;
@export var sfx_control : Node = null;

func _ready() -> void:
	if(music_control != null):
		pass;

	if(sfx_control != null):
		pass;

func play_sfx(sfx_name : String, random_pitch : bool = false) -> void:
	if(sfx_control != null):
		var sfx : AudioStreamPlayerExt = sfx_control.get_node_or_null(sfx_name);
		if(sfx != null):
			if(random_pitch):
				sfx.play_random_pitch();
			else:
				sfx.play_normal();

func play_music(music_name : String, random_pitch : bool = false) -> void:
	if(music_control != null):
		var music : AudioStreamPlayerExt = music_control.get_node_or_null(music_name);
		if(music != null):
			if(random_pitch):
				music.play_random_pitch();
			else:
				music.play_normal();
