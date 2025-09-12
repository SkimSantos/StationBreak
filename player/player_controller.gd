extends Character
class_name PlayerController

@export_subgroup("Stats")
@export_range(50, 250, 5) var speed : float = 100.0;
var direction : Vector2 = Vector2.ZERO;

@export var player_control_area : Control;

@export_range(0.1, 1, 0.05) var fire_rate : float = 0.25; # bullets per second
var time_since_last_fire : float = 0.0;
var firing : bool = false;

@export_subgroup("Parts")
@export var nuzzle : Node2D;
@export var bullet_scene : PackedScene;

func _enter_tree() -> void:
	Controller.set_player(self);

func _process(delta: float) -> void:
	if(position.x > player_control_area.size.x):
		position.x = player_control_area.size.x;
		direction = Vector2.ZERO;
	elif (position.x < 0):
		position.x = 0;
		direction = Vector2.ZERO;
	else:
		position += direction * speed * delta;

	if(time_since_last_fire < fire_rate):
		time_since_last_fire += delta;

	if(firing and time_since_last_fire >= fire_rate):
		fire_bullet();
		time_since_last_fire = 0.0;
		

func set_direction(dir: Vector2) -> void:
	direction = dir;

func set_fire(active : bool) -> void:
	firing = active;

func fire_bullet() -> void:
	var bullet = bullet_scene.instantiate();
	bullet.global_position = nuzzle.global_position;
	Controller.level.add_child(bullet);
	bullet.set_direction(Vector2.UP);

func on_hp_zero() -> void:
	Controller.input_manager.input_level_active = false;
	queue_free();
