extends Rustfang
class_name Sxh2

var parent_control : Control = null;

func set_ready() -> void:
	super.set_ready();
	parent_control = get_parent() as Control;
	random.randomize();
	if(random.randi_range(0, 1) == 0):
		direction = Vector2.LEFT + Vector2.DOWN;
		if(sprite != null):
			sprite.frame_coords.y = 2;
	else:
		direction = Vector2.RIGHT + Vector2.DOWN;
		if(sprite != null):
			sprite.frame_coords.y = 1;

func _process(delta: float) -> void:
	super._process(delta);

	direction = direction.normalized();
	position += direction * speed_x * delta;

	if(sprite != null):
		animation_timer += delta;
		if(animation_timer >= animation_frame_rate):
			animation_timer = 0.0;
			if(sprite.frame_coords.x >= sprite.hframes -1):
				sprite.frame_coords.x = 0;
			else:
				sprite.frame_coords.x += 1;

	
	if(parent_control != null):
		if(position.x > parent_control.size.x):
			position.x = parent_control.size.x;
			direction += Vector2.LEFT * 2;
			if(sprite != null):
				sprite.frame_coords.y = 2;
		elif(position.x < 0):
			position.x = 0;
			direction += Vector2.RIGHT * 2;
			if(sprite != null):
				sprite.frame_coords.y = 1;
			
		if(position.y > parent_control.size.y):
			position.y = parent_control.size.y;
			direction += Vector2.UP * 2;
		elif(position.y < 0):
			position.y = 0;
			direction += Vector2.DOWN * 2;
	
