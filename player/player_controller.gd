extends Character
class_name PlayerController

@export var player_sprite : Sprite2D;
@export var animation_frame_rate : float = 0.2;
var animation_timer : float = 0.0;

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
@export var instantiate_bullets : int = 10;
var bullet_array : Array[Bullet] = [];
var fired_bullets : Array[Bullet] = [];

func _enter_tree() -> void:
	Controller.set_player(self);

func set_middle_position() -> void:
	if(player_control_area != null):
		player_control_area.visible = true;
		self.position.x = player_control_area.size.x / 2;

func initiate_bullets() -> void:
	if(bullet_scene != null):
		for i in range(0, instantiate_bullets):
			var bullet = bullet_scene.instantiate() as Bullet;
			if(bullet == null):
				print("Bullet is null");
				return;
			bullet.name = "%s_Bullet_%d" % [self.name, i];
			bullet.bullet_type = type;
			bullet.visible = false;
			bullet.delete_callable = Callable(self, "on_bullet_deleted");
			bullet.set_process(false);
			bullet.initiate_bullet();
			Controller.level.add_child(bullet);
			bullet_array.append(bullet);

func _process(delta: float) -> void:
	animation_timer += delta;
	if(animation_timer >= animation_frame_rate):
		animation_timer = 0.0;
		if(player_sprite.frame_coords.x >= player_sprite.hframes -1):
			player_sprite.frame_coords.x = 0;
		else:
			player_sprite.frame_coords.x += 1;

	if(position.x > player_control_area.size.x):
		position.x = player_control_area.size.x;
		direction = Vector2.ZERO;
		player_sprite.frame_coords.y = 0;
	elif (position.x < 0):
		position.x = 0;
		direction = Vector2.ZERO;
		player_sprite.frame_coords.y = 0;
	else:
		position += direction * speed * delta;

	if(time_since_last_fire < fire_rate):
		time_since_last_fire += delta;

	if(firing and time_since_last_fire >= fire_rate):
		fire_bullet();
		time_since_last_fire = 0.0;
		

func set_direction(dir: Vector2) -> void:
	direction = dir;
	if(direction == Vector2.LEFT):
		player_sprite.frame_coords.y = 1;
	elif(direction == Vector2.RIGHT):
		player_sprite.frame_coords.y = 2;
	else:
		player_sprite.frame_coords.y = 0;

func set_fire(active : bool) -> void:
	firing = active;

func fire_bullet() -> void:
	if(bullet_array.size() > 0):
		var bullet = bullet_array.pop_front() as Bullet;
		fired_bullets.append(bullet);
		if(bullet == null):
			print("Bullet is null on fire player");
			return;
		bullet.global_position = nuzzle.global_position;
		bullet.set_direction(Vector2.UP);
		bullet.visible = true;
		bullet.set_process(true);
		bullet.fired();
		if(SoundController != null):
			SoundController.play_sfx("bullet_shoot", true);
	else:
		var bullet = bullet_scene.instantiate();
		bullet.bullet_type = type;
		fired_bullets.append(bullet);
		bullet.global_position = nuzzle.global_position;
		Controller.level.add_child(bullet);
		bullet.set_direction(Vector2.UP);
		bullet.fired();
		if(SoundController != null):
			SoundController.play_sfx("bullet_shoot", true);

func on_hp_zero() -> void:
	for bullet in bullet_array:
		bullet.queue_free();
	for bullet in fired_bullets:
		bullet.queue_free();
	Controller.input_manager.input_level_active = false;
	Controller.main_scene.on_player_dead();
	Controller.main_scene.set_label_text("You Died!");
	if(SoundController != null):
		SoundController.play_sfx("explosion_1", true);
	if(Controller.main_scene != null && Controller.main_scene.explosion != null):
		var explosion_instance = Controller.main_scene.explosion.instantiate();
		if(explosion_instance != null):
			explosion_instance.global_position = self.global_position;
			Controller.level.add_child(explosion_instance);
	queue_free();

func on_bullet_deleted(bullet: Bullet) -> void:
	fired_bullets.erase(bullet);
	bullet_array.append(bullet);
