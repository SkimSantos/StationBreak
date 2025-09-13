extends Rustfang
class_name Shredder

func set_ready() -> void:
	super.set_ready();
	print(bullet_array);
	random.randomize();
	if(random.randi_range(0, 1) == 0):
		direction = Vector2.LEFT;
	else:
		direction = Vector2.RIGHT;

func _process(delta: float) -> void:
	super._process(delta);

	position += direction * speed_x * delta;

	if(position.x > max_x_pos):
		position.x = max_x_pos;
		direction = Vector2.LEFT;
	elif(position.x < 0):
		position.x = 0;
		direction = Vector2.RIGHT;
