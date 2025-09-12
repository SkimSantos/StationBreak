extends Node
class_name InputManager

var input_active : bool = true;

func _enter_tree() -> void:
	Controller.set_input_manager(self);

func _input(event: InputEvent) -> void:
	if(!input_active):
		return;

	if event.is_action_pressed("left"):
		print("left?")
		Controller.level.set_process_active(true);
	elif(event.is_action_released("left")):
		Controller.level.set_process_active(false);

	if event.is_action_pressed("right"):
		Controller.level.set_process_active(true);
	elif event.is_action_released("right"):
		Controller.level.set_process_active(false);