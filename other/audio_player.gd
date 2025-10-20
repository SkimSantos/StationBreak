extends AudioStreamPlayer
class_name AudioStreamPlayerExt

enum PlayMode {
	PLAY_ON_TOP,
	RESTART,
	IGNORE
}

@export var play_mode : PlayMode = PlayMode.PLAY_ON_TOP;

@export var min_pitch_scale : float = 0.8;
@export var max_pitch_scale : float = 1.2;

var delete_on_finished : bool = false;

func _ready():
	if(delete_on_finished):
		connect("finished", Callable(self, "queue_free"));

func _process(_delta):
	if(is_playing() == false and delete_on_finished):
		queue_free()

func play_normal() -> void:
	if(play_mode == PlayMode.PLAY_ON_TOP):
		if(is_playing()):
			var new_instance = duplicate();
			self.add_child(new_instance);
			new_instance.delete_on_finished = true;
			new_instance.play();
		else:
			play();
	elif(play_mode == PlayMode.RESTART):
		stop();
		play(0.0);
	elif(play_mode == PlayMode.IGNORE):
		if(!is_playing()):
			play();

func play_random_pitch() -> void:
	pitch_scale = randf_range(min_pitch_scale, max_pitch_scale);
	play_normal();
