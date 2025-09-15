extends Control
class_name UIControl

@export var pause_menu : Control;
var ignore_input : bool = false;

func _ready() -> void:
	set_process_mode(PROCESS_MODE_ALWAYS);
	Controller.set_ui(self);
	pause_menu.visible = false;
	get_tree().paused = false;

func toggle_pause() -> void:
	if(ignore_input):
		return;
	if(Controller.player == null):
		pause_menu.visible = false;
		return;
	if(pause_menu.visible):
		pause_menu.visible = false;
		Controller.input_manager.input_level_active = true;
	else:
		pause_menu.visible = true;
		Controller.input_manager.input_level_active = false;
		get_tree().paused = true;
