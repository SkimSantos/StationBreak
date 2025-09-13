extends Control
class_name MainScene

@export var levels : Array[PackedScene];
var current_level_index : int = 0;
var current_level : LevelBase = null;

@export var temp_label : Label;

func _ready() -> void:
	Controller.set_main_scene(self);
	set_level(current_level_index);

func set_level(index: int) -> void:
	Controller.main_scene.set_label_text("");
	if(current_level != null):
		current_level.queue_free();
	
	current_level_index = index;
	current_level = levels[current_level_index].instantiate();
	add_child(current_level);
	current_level.set_position(Vector2.ZERO);
	current_level.set_size(self.size);
	await get_tree().process_frame;
	current_level.set_ready();

func set_label_text(text: String) -> void:
	if(temp_label):
		if(text == ""):
			temp_label.visible = false;
		else:
			temp_label.visible = true;
			temp_label.text = text;
