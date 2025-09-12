extends Character
class_name EnemyBase

var direction : Vector2 = Vector2.DOWN;
@export var speed : float = 100.0;
@export var random_timer : float = 1.0;
@export var change_ai_y : int = 200;
@export var damage : int = 1;

var random = RandomNumberGenerator.new();
var change_direction_time : float = 0.0;

var follow_player : bool = false;

func _ready() -> void:
	if(area):
		area.connect("area_entered", Callable(self, "on_area_entered"));

func _process(delta: float) -> void:
	if(follow_player):
		var player = Controller.player;
		if(player):
			var diff = global_position - player.global_position
			if(abs(diff.y) > abs(diff.x)):
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

	position += direction * speed * delta;
	if(position.y > 700):
		queue_free();

func randomize_direction() -> void:
	random.randomize();
	var new_d = random.randi_range(0, 100);
	change_direction_time = random.randf_range(0.2, random_timer);

	if(new_d < 25):
		direction = Vector2.LEFT;
	elif(new_d < 50):
		direction = Vector2.RIGHT;
	else:
		direction = Vector2.DOWN;

func on_area_entered(a: Node) -> void:
	if a.get_parent() is PlayerController:
		var player = a.get_parent() as PlayerController;
		player.on_bullet_hit(damage);
		queue_free();
