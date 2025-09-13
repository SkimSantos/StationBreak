extends EnemyBase
class_name Rustfang

@export var bullet_scene : PackedScene;
@export var shoot_interval : float = 2.0;
@export var number_bullet_pre_instance : int = 10;
@export var nuzzle : Node2D;

var bullet_array : Array[Bullet] = [];
var fired_bullets : Array[Bullet] = [];
var shoot_time : float = 0.0;

func set_ready() -> void:
	if(bullet_scene != null && bullet_array.size() == 0):
		for i in range(0, number_bullet_pre_instance):
			var bullet = bullet_scene.instantiate() as Bullet;
			if (bullet == null):
				print("Bullet is null");
				return;
			bullet.name = "%s_Bullet_%d" % [self.name, i];
			bullet.bullet_type = type;
			bullet.visible = false;
			bullet.delete_callable = Callable(self, "on_bullet_deleted");
			bullet.set_process(false);
			bullet.initiate_bullet();
			if(!bullet_array.has(bullet)):
				bullet_array.append(bullet);
				Controller.level.add_child(bullet);
			else:
				bullet.queue_free();

func _process(delta: float) -> void:
	if(shoot_time >= shoot_interval):
		shoot_time = 0.0;
		fire_bullet();
	else:
		shoot_time += delta;

func fire_bullet() -> void:
	if(bullet_array.size() > 0):
		var bullet = bullet_array.pop_front() as Bullet;
		fired_bullets.append(bullet);
		if(bullet == null):
			print("Bullet is null");
			return;
		bullet.global_position = nuzzle.global_position;
		bullet.set_direction(Vector2.DOWN);
		bullet.visible = true;
		bullet.fired();
	else:
		var bullet : Bullet = bullet_scene.instantiate();
		bullet.bullet_type = type;
		fired_bullets.append(bullet);
		bullet.global_position = nuzzle.global_position;
		Controller.level.add_child(bullet);
		bullet.name = "%s_newBullet" % [self.name];
		bullet.delete_callable = Callable(self, "on_bullet_deleted");
		bullet.set_direction(Vector2.DOWN);
		bullet.fired();

func on_bullet_deleted(bullet: Bullet) -> void:
	bullet.visible = false;
	bullet.set_process(false);
	fired_bullets.erase(bullet);
	if(bullet_array.has(bullet)):
		return;
	bullet_array.append(bullet);

func on_hp_zero() -> void:
	for bullet in bullet_array:
		bullet.queue_free();
	Controller.level.enemy_killed(self);
