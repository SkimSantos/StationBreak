extends Control
class_name MainScene

@export var levels : Array[PackedScene];
var current_level_index : int = 0;
var current_level : LevelBase = null;

func _ready() -> void:
	Controller.set_main_scene(self);
	set_level(current_level_index);

func set_level(index: int) -> void:
	if(current_level != null):
		current_level.queue_free();
	
	current_level_index = index;
	current_level = levels[current_level_index].instantiate();
	add_child(current_level);
 