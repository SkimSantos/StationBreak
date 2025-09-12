extends Node2D
class_name Bullet

var direction : Vector2 = Vector2.UP;
@export var speed : float = 400.0;
@export var damage : int = 1;
@export var area : Area2D;

func _ready() -> void:
	area.connect("area_entered", Callable(self, "on_body_entered"));

func on_body_entered(body: Node) -> void:
	if body.get_parent() is Character:
		body.get_parent().on_bullet_hit(damage);
		queue_free();

func set_direction(dir: Vector2) -> void:
	direction = dir;

func _process(delta: float) -> void:
	position += direction * speed * delta;
	if(position.y < -100):
		queue_free();
