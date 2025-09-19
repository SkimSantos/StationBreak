extends Control
class_name LevelBase

@export var enemies_spawner : Control;
@export var enemies_spawner_distance : Vector2;
var enemies_positions : Array[int] = [];
var enemies_offset : Vector2 = Vector2.ZERO;

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
	enemies_offset.x = enemies_spawner.size.x - ((x_int-1) * enemies_spawner_distance.x);
	enemies_offset.y = enemies_spawner.size.y - ((y_int-1) * enemies_spawner_distance.y);
	enemies_offset = enemies_offset / 2;
	
	enemies_positions.resize(y_int * x_int);
	var enemy_count_total : int = 0;
	var enemy_type_index : int = 0;

	for i in range(enemies_count.size()):
		enemy_count_total += enemies_count[i];
		while(enemy_count_total > (y_int * x_int) && enemy_type_index < enemies_count.size() && enemy_type_index < i):
			enemies_count[enemy_type_index] -= enemy_count_total - (y_int * x_int);
			if(enemies_count[enemy_type_index] <= 0):
				enemy_count_total += enemies_count[enemy_type_index] * -1;
				enemies_count[enemy_type_index] = 0;
				enemy_type_index += 1;

	spawn_enemies();
	if(Controller.player != null):
		Controller.player.initiate_bullets();
		Controller.player.set_fire(true);
		Controller.player.set_middle_position();
	Controller.main_scene.show_level();
	set_process_active(false);

func set_process_active(active: bool) -> void:
	if(spawned_enemies.size() != 0):
		get_tree().paused = !active;
	else:
		get_tree().paused = false;

func spawn_enemies() -> void:
	random.randomize();
	for i : int in range(enemies_scenes.size()):
		for j : int in range(enemies_count[i]):
			if(enemies_positions.size() == spawned_enemies.size()):
				return;
			var enemy = enemies_scenes[i].instantiate() as EnemyBase;
			var pos : Vector2 = get_random_position();
			enemies_spawner.add_child(enemy);
			enemy.position = enemies_offset + pos;
			enemy.max_x_pos = enemies_spawner.size.x;
			spawned_enemies.append(enemy);
			enemy.set_ready();

func get_random_position() -> Vector2:
	random.randomize();
	if(enemies_positions.size() == 0):
		return Vector2.ZERO;

	var pos_index = random.randi_range(0, enemies_positions.size() -1);
	if(enemies_positions[pos_index] == 1 && enemies_positions.size() > spawned_enemies.size()):
		pos_index = enemies_positions.find(0, 0);
		if(pos_index == -1):
			return Vector2.ZERO;

	var pos : Vector2 = Vector2.ZERO;

	var int_x : int = int(enemies_spawner.size.x / enemies_spawner_distance.x);
	var int_y : int  = enemies_positions.size() / int_x;

	var index_x : int = floor((pos_index + 1) / float(int_x));
	if(index_x < 0):
		index_x = 0;
	
	var index_y : int = (pos_index) - (int_x * index_x) - 1;
	if(index_y < 0):
		index_y = 0;

	if(pos_index % int_x == 0 && pos_index != 0):
		index_x -= 1;
		index_y = int_x - 1;
	
	pos.x = (enemies_spawner_distance.x * index_y);
	pos.y = (index_x * enemies_spawner_distance.y);

	enemies_positions[pos_index] = 1;

	return pos;

func enemy_killed(enemy: EnemyBase) -> void:
	if(Controller.main_scene != null && Controller.main_scene.explosion != null):
		var explosion_instance : AnimatedSprite2D = Controller.main_scene.explosion.instantiate() as AnimatedSprite2D;
		if(explosion_instance != null):
			explosion_instance.flip_h = random.randi_range(0, 1) == 1;
			explosion_instance.flip_v = random.randi_range(0, 1) == 1;
			explosion_instance.global_position = enemy.global_position;
			Controller.level.add_child(explosion_instance);
	spawned_enemies.erase(enemy);
	enemy.queue_free();
	if(spawned_enemies.size() == 0):
		Controller.player.set_fire(false);
		Controller.main_scene.completed_level();
