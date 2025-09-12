extends Node2D
class_name Character

@export_category("Base")
@export var max_hp : int = 1;
var hp : int = max_hp;
@export var area : Area2D;

func on_bullet_hit(damage : int) -> void:
    hp -= damage;
    if(hp <= 0):
        on_hp_zero();

func on_hp_zero() -> void:
    queue_free();