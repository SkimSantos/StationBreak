extends Node2D
class_name Bullet

var direction : Vector2 = Vector2.UP;
@export var bullet_type : Character.eType = Character.eType.PLAYER;
@export var speed : float = 400.0;
@export var damage : int = 1;
@export var area : Area2D;


var delete_callable : Callable;

func _ready() -> void:
	area.connect("area_entered", Callable(self, "on_body_entered"));

func initiate_bullet() -> void:
	if(bullet_type == Character.eType.PLAYER):
		global_position = Vector2(-1000, 0);
	else:
		global_position = Vector2(-1200, 0);

func fired() -> void:
	set_process(true);
	area.monitoring = true;
	area.monitorable = true;

func on_body_entered(body: Node) -> void:
	if body.get_parent() is Character:
		if(body.get_parent() as Character).type == bullet_type:
			return;
		body.get_parent().on_bullet_hit(damage);
		on_hit();
	if body.get_parent() is Bullet:
		if((body.get_parent() as Bullet).bullet_type == bullet_type):
			return;
		body.get_parent().on_hit();
		on_hit();

func set_direction(dir: Vector2) -> void:
	direction = dir;

func _process(delta: float) -> void:
	position += direction * speed * delta;
	if(direction == Vector2.UP && global_position.y < -100) || (direction == Vector2.DOWN && global_position.y > 1000):
		on_hit();
	
func on_hit() -> void:
	if(delete_callable.is_valid()):
		self.visible = false;
		set_process(false);
		area.monitoring = false;
		area.monitorable = false;
		initiate_bullet();
		delete_callable.call(self);
		return;
	queue_free();
