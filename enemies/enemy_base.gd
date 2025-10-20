extends Character
class_name EnemyBase

@export var score_points : int = 1;

@export var sprite : Sprite2D;
@export var animation_frame_rate : float = 0.2;
var animation_timer : float = 0.0;

var direction : Vector2 = Vector2.DOWN;
@export_range(50, 500, 1) var speed_x : float = 150.0;
@export_range(50, 500, 1) var speed_y : float = 100.0;
@export var random_timer : float = 1.0;
@export var change_ai_y : int = 200;
@export var damage : int = 1;


var max_x_pos : int = 550;

var random = RandomNumberGenerator.new();
var change_direction_time : float = 0.0;

var follow_player : bool = false;

func set_ready() -> void:
	if(area):
		area.connect("area_entered", Callable(self, "on_area_entered"));
	
	randomize_direction();

func _process(delta: float) -> void:
	if(sprite != null):
		animation_timer += delta;
		if(animation_timer >= animation_frame_rate):
			animation_timer = 0.0;
			if(sprite.frame_coords.x >= sprite.hframes -1):
				sprite.frame_coords.x = 0;
			else:
				sprite.frame_coords.x += 1;
	if(follow_player):
		var player = Controller.player;
		if(player):
			var diff = global_position - player.global_position
			if(abs(diff.x) <= 20.0):
				direction = Vector2.DOWN;
			elif(diff.x > 0):
				direction = Vector2.LEFT;
			else:
				direction = Vector2.RIGHT;
	else:
		var player = Controller.player;
		if(player):
			if(player.global_position.y - global_position.y <= change_ai_y):
				follow_player = true;
		
		if(change_direction_time >= random_timer):
			change_direction_time = 0.0;
			randomize_direction();
		else:
			change_direction_time += delta;

	var dir = direction * delta;
	if(direction.x == 0.0):
		dir *= speed_y;
	else:
		dir *= speed_x;

	position += dir;

	if(sprite != null):
		if(direction == Vector2.LEFT):
			sprite.frame_coords.y = 1;
		elif(direction == Vector2.RIGHT):
			sprite.frame_coords.y = 2;
		else:
			sprite.frame_coords.y = 0;

	if(position.x > max_x_pos):
		position.x = max_x_pos;
		direction = Vector2.LEFT;
		sprite.frame_coords.y = 1;
	elif(position.x < 0):
		position.x = 0;
		direction = Vector2.RIGHT;
		sprite.frame_coords.y = 2;
	if(position.y > DisplayServer.window_get_size().y + 50):
		on_hp_zero(true);

func randomize_direction() -> void:
	random.randomize();
	var new_d = random.randi_range(0, 100);
	change_direction_time = random.randf_range(0.2, random_timer);

	if(new_d <= 35):
		direction = Vector2.LEFT;
	elif(new_d <= 70):
		direction = Vector2.RIGHT;
	else:
		direction = Vector2.DOWN;

func on_area_entered(a: Node) -> void:
	if a.get_parent() is PlayerController:
		var player = a.get_parent() as PlayerController;
		player.on_bullet_hit(damage);
		Controller.level.enemy_killed(self);

func on_hp_zero(ignore_points : bool = false) -> void:
	Controller.level.enemy_killed(self, ignore_points);
	if(SoundController != null):
		SoundController.play_sfx("explosion_1", true);
