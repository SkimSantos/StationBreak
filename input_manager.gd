extends Node
class_name InputManager

var input_active : bool = true;
var input_level_active : bool = true;

func _enter_tree() -> void:
	Controller.set_input_manager(self);

func _input(event: InputEvent) -> void:
	if(!input_active):
		return;
	
	if(input_level_active):
		# Pressed
		if event.is_action_pressed("left"):
			Controller.level.set_process_active(true);
			Controller.player.set_direction(Vector2.LEFT);
		if event.is_action_pressed("right"):
			Controller.level.set_process_active(true);
			Controller.player.set_direction(Vector2.RIGHT);

		# Released
		if(event.is_action_released("left")):
			if !Input.is_action_pressed("right"):
				Controller.level.set_process_active(false);
				Controller.player.set_direction(Vector2.ZERO);
			else:
				Controller.level.set_process_active(true);
				Controller.player.set_direction(Vector2.RIGHT);
		if event.is_action_released("right"):
			if !Input.is_action_pressed("left"):
				Controller.level.set_process_active(false);
				Controller.player.set_direction(Vector2.ZERO);
			else:
				Controller.level.set_process_active(true);
				Controller.player.set_direction(Vector2.LEFT);

	# Debug
	if(event.is_action_pressed("ui_pause")):
		Controller.ui.toggle_pause();

	if(event.is_action_pressed("reset_level")):
		input_level_active = false;
		Controller.reset_level();
