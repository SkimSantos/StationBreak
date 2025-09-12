extends Node2D
class_name LevelBase

func _enter_tree() -> void:
	Controller.set_level(self);

func _ready():
	set_process_active(false);

func set_process_active(active: bool) -> void:
	get_tree().paused = !active;
