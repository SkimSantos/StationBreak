extends Rustfang
class_name Shredder

@export_range(0,1,0.1) var speed_variantion : float = 0.5;

func set_ready() -> void:
	super.set_ready();
	random.randomize();
	if(random.randi_range(0, 1) == 0):
		direction = Vector2.LEFT;
	else:
		direction = Vector2.RIGHT;
	speed_x = random.randf_range(speed_x - (speed_x * speed_variantion), speed_x + (speed_x * speed_variantion));

func _process(delta: float) -> void:
	super._process(delta);

	position += direction * speed_x * delta;

	if(sprite != null):
		animation_timer += delta;
		if(animation_timer >= animation_frame_rate):
			animation_timer = 0.0;
			if(sprite.frame_coords.x >= sprite.hframes -1):
				sprite.frame_coords.x = 0;
			else:
				sprite.frame_coords.x += 1;

	if(position.x > max_x_pos):
		position.x = max_x_pos;
		direction = Vector2.LEFT;
		if(sprite != null):
			sprite.frame_coords.y = 2;
	elif(position.x < 0):
		position.x = 0;
		direction = Vector2.RIGHT;
		if(sprite != null):
			sprite.frame_coords.y = 1;
