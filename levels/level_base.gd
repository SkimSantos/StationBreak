extends Control
class_name LevelBase

@export var enemies_spawner : Control;
@export var enemies_spawner_distance : Vector2;
var enemies_positions : Array[int] = [];

@export var enemies_scenes : Array[PackedScene];
@export var enemies_count : Array[int];

var spawned_enemies : Array[EnemyBase] = [];

var random = RandomNumberGenerator.new();

func _enter_tree() -> void:
	Controller.set_level(self);

func _ready() -> void:
	set_process_active(false);

func set_ready():
	var x_int : int = int(enemies_spawner.size.x / enemies_spawner_distance.x);
	var y_int : int  = int(enemies_spawner.size.y / enemies_spawner_distance.y);
	enemies_positions.resize(y_int * x_int);
	spawn_enemies();
	if(Controller.player != null):
		Controller.player.initiate_bullets();
		Controller.player.set_fire(true);

func set_process_active(active: bool) -> void:
	get_tree().paused = !active;

func spawn_enemies() -> void:
	random.randomize();
	for i : int in range(enemies_scenes.size()):
		for j : int in range(enemies_count[i]):
			var enemy = enemies_scenes[i].instantiate() as EnemyBase;
			var pos : Vector2 = get_random_position();
			enemies_spawner.add_child(enemy);
			enemy.position = enemies_spawner.position + pos;
			enemy.max_x_pos = enemies_spawner.size.x;
			spawned_enemies.append(enemy);
			enemy.set_ready();

func get_random_position() -> Vector2:
	random.randomize();
	if(enemies_positions.size() == 0):
		return Vector2.ZERO;

	var pos_index = random.randi_range(0, enemies_positions.size() - 1);
	if(enemies_positions[pos_index] == 1):
		return get_random_position();

	var pos : Vector2 = Vector2.ZERO;

	var int_x : int = int(enemies_spawner.size.x / enemies_spawner_distance.x);
	var int_y : int  = enemies_positions.size() / int_x;
	
	pos.x = (enemies_spawner_distance.x * int(pos_index / int_y));
	pos.y = (int(pos_index / int_x) * enemies_spawner_distance.y);

	enemies_positions[pos_index] = 1;

	return pos;

func enemy_killed(enemy: EnemyBase) -> void:
	spawned_enemies.erase(enemy);
	enemy.queue_free();
	if(spawned_enemies.size() == 0):
		Controller.player.set_fire(false);
		Controller.main_scene.set_label_text("Level Complete!");
		print("Completed");
