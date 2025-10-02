extends Control
class_name TopBar

@export var enemies_count : Label;
@export var score : Label;


func _ready() -> void:
	Controller.set_topbar(self);
	enemies_count.text = "%o/%o" % [0,0];
	score.text = "%08o" % 0;

func set_score(new_score: int) -> void:
	score.text = "%08o" % new_score;

func set_enemies_count(current: int, total: int) -> void:
	enemies_count.text = "%o/%o" % [total - current, total];
