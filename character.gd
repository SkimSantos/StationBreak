extends Node2D
class_name Character
enum eType {
	PLAYER,
	ENEMY
}

@export var type : eType = eType.ENEMY;
@export_category("Base")
@export var max_hp : int = 1;
var hp : int = max_hp;
@export var area : Area2D;

func on_bullet_hit(damage : int) -> void:
	hp -= damage;
	if(hp <= 0):
		on_hp_zero();

func on_hp_zero() -> void:
	if(Controller.main_scene != null && Controller.main_scene.explosion != null):
		var explosion_instance = Controller.main_scene.explosion.instantiate();
		if(explosion_instance != null):
			explosion_instance.global_position = self.global_position;
			Controller.level.add_child(explosion_instance);
	queue_free();