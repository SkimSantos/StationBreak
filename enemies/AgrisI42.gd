extends Rustfang
class_name AgrisI42

var parent_control : Control = null;

func set_ready() -> void:
	super.set_ready();
	parent_control = get_parent() as Control;
	if(Controller.player != null):
		if(Controller.player.global_position.x < self.global_position.x):
			direction = Vector2.LEFT;
			if(sprite != null):
				sprite.frame_coords.y = 2;
		else:
			direction = Vector2.RIGHT;
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
	
	if(Controller.player != null):
		if(abs(self.global_position.x - Controller.player.global_position.x) > 50):
			if(Controller.player.global_position.x < self.global_position.x):
				direction = Vector2.LEFT;
				if(sprite != null):
					sprite.frame_coords.y = 2;
			else:
				direction = Vector2.RIGHT;
				if(sprite != null):
					sprite.frame_coords.y = 1;
		elif(abs(self.global_position.x - Controller.player.global_position.x) < 10):
			direction = Vector2.ZERO;
			if(sprite != null):
				sprite.frame_coords.y = 0;

	if(parent_control != null):
		if(position.x > parent_control.size.x):
			position.x = parent_control.size.x;
			direction = Vector2.ZERO;
		elif(position.x < 0):
			position.x = 0;
			direction = Vector2.ZERO;
