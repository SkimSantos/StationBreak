extends Control
class_name MainScene

@export var levels : Array[PackedScene];
var current_level_index : int = 0;
var current_level : LevelBase = null;

@export var game_control : Control;

@export var animator : AnimationPlayer;
@export var temp_label : Label;

@export var background_control : Control;
@export var star_controller : Node2D;
@export_range(0.0, 5.0, 0.1) var background_scroll_speed : float = 0.1;
@export_range(0, 100, 1) var star_grid_space : int = 20;
@export var temp_star_sprite : Sprite2D;
@export var star_percent : int = 30;

@export_subgroup("Effects")
@export var explosion : PackedScene;

var stars_array : Array[Array] = [];
var back_distance_runned : float = 0.0;
var random = RandomNumberGenerator.new();

var endless_on_last : bool = false;
var endless_count : int = 0;

func _ready() -> void:
	Controller.set_main_scene(self);
	endless_on_last = false;
	endless_count = 0;
	if(animator):
		animator.play("init");
	_create_stars();
	

func _create_stars() -> void:
	if(background_control == null || temp_star_sprite == null || star_controller == null):
		return;
	if(temp_star_sprite.get_parent() != null):
		temp_star_sprite.get_parent().remove_child(temp_star_sprite);
	if(star_controller.get_parent() != null):
		star_controller.get_parent().remove_child(star_controller);
	
	var cols : int = int(background_control.size.x / star_grid_space) + 2;
	var rows : int = int(background_control.size.y / star_grid_space) + 2;
	stars_array.resize(rows);
	for i in range(rows):
		if(i >= 1):
			var new_controller = star_controller.duplicate() as Node2D;
			new_controller.position = Vector2(0.0, -star_grid_space + (i * star_grid_space));
			background_control.add_child(new_controller);
		else:
			star_controller.position.y = -star_grid_space;
			background_control.add_child(star_controller);
		stars_array[i] = [];
		stars_array[i].resize(cols);

	random.randomize();
	var star_count : int = floor(cols * rows * star_percent / 100);
	for i in range(star_count):
		var star = temp_star_sprite.duplicate() as Sprite2D;
		if(star == null):
			return;
		
		var pos : Vector2i = Vector2i(random.randi_range(0, cols -1), random.randi_range(0, rows -1));
		if(stars_array[pos.y][pos.x] != null):
			while(stars_array[pos.y][pos.x] != null):
				pos = Vector2i(random.randi_range(0, cols -1), random.randi_range(0, rows -1));
		
		star.position = Vector2(pos.x * star_grid_space, 0.0);
		star.frame = random.randi_range(0, (temp_star_sprite.hframes * temp_star_sprite.vframes) - 1);

		stars_array[pos.y][pos.x] = star;
		background_control.get_child(pos.y).add_child(star);

func _process(delta: float) -> void:
	if(background_control == null || star_controller == null):
		return;
	var pos_increment : float = background_scroll_speed * delta;
	back_distance_runned += pos_increment;

	for c in background_control.get_children():
		c.position.y += pos_increment;

	if(back_distance_runned >= star_grid_space):
		back_distance_runned = 0.0;
		rearrange_bottom_row();

func rearrange_bottom_row() -> void:
	if(stars_array.size() == 0):
		return;
	var cols : int = stars_array[0].size();
	var bottom_row : Array = stars_array.pop_back();
	var temp_row : Array = [];
	temp_row.resize(cols);

	var bottom_row_node : Node2D = null;

	for star in bottom_row:
		if(star != null):
			if(bottom_row_node == null):
				bottom_row_node = star.get_parent() as Node2D;
			
			star.position.y = -star_grid_space;
			var pos_x : int = random.randi_range(0, cols -1);
			while(temp_row[pos_x] != null):
				pos_x = random.randi_range(0, cols -1);

			star.position.x = pos_x * star_grid_space;
			star.frame = random.randi_range(0, (temp_star_sprite.hframes * temp_star_sprite.vframes) - 1);
			temp_row[pos_x] = star;
	
	if(bottom_row_node != null):
		bottom_row_node.position.y = -star_grid_space;
	
	stars_array.push_front(temp_row);
	

func start_game() -> void:
	set_level(current_level_index);

func reset_level() -> void:
	if(Controller.ui.pause_menu.visible):
		Controller.ui.toggle_pause();
	Controller.ui.ignore_input = false;
	set_level(current_level_index);

func quit_game() -> void:
	get_tree().quit();

func on_player_dead() -> void:
	if(animator):
		animator.play("game_over");

func to_main_menu() -> void:
	current_level.queue_free();
	current_level = null;
	current_level_index = 0;
	endless_on_last = false;
	endless_count = 0;
	Controller.input_manager.input_level_active = false;
	get_tree().paused = false;
	Controller.ui.toggle_pause();
	if(animator):
		animator.play("init");

func set_level(index: int) -> void:
	if(current_level != null):
		current_level.queue_free();
	
	current_level_index = index;
	current_level = levels[current_level_index].instantiate();
	if(endless_on_last):
		for i in range(current_level.enemies_count.size()):
			current_level.enemies_count[i] += random.randi_range(0, 2 * endless_count);
	game_control.add_child(current_level);
	current_level.set_position(Vector2.ZERO);
	current_level.set_size(game_control.size);
	await get_tree().process_frame;
	current_level.set_ready();
	Controller.ui.ignore_input = false;

func set_label_text(text: String) -> void:
	if(temp_label):
		if(text == ""):
			temp_label.visible = false;
		else:
			temp_label.visible = true;
			temp_label.text = text;

func completed_level() -> void:
	current_level_index += 1;
	if(current_level_index >= levels.size()):
		endless_count += 1;
		endless_on_last = true;
		current_level_index = levels.size() - 1;
	Controller.ui.ignore_input = true;
	animator.play("next_level");
