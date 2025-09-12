extends Node2D
class_name PlayerController

func _enter_tree() -> void:
	Controller.set_player(self);

func _exit_tree() -> void:
	Controller.set_player(null);
