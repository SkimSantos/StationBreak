extends EnemyBase

@export var timer_to_kamikaze : float = 1.0;
var kami_timer : float = 0.0;


func _process(delta: float) -> void:
	var player = Controller.player;
	if(sprite != null):
		animation_timer += delta;
		if(animation_timer >= animation_frame_rate):
			animation_timer = 0.0;
			if(sprite.frame_coords.x >= sprite.hframes -1):
				sprite.frame_coords.x = 0;
			else:
				sprite.frame_coords.x += 1;
	if(follow_player):
		if(player):
			var diff = global_position - player.global_position
			if(diff.x > 0):
				direction = Vector2.LEFT;
			else:
				direction = Vector2.RIGHT;
			
			if(abs(diff.x) < 70.0):
				follow_player = false;
				kami_timer = 0.0;
	elif(kami_timer < timer_to_kamikaze):
		kami_timer += delta;
		if(kami_timer >= timer_to_kamikaze):
			direction = Vector2.DOWN;
		elif(player):
			var diff = global_position - player.global_position
			if(abs(diff.x) > 100.0):
				kami_timer = 0.0;
				follow_player = true;

	var dir = direction * delta;
	if(direction.x == 0.0):
		dir *= speed_y;
	else:
		dir *= speed_x;

	position += dir;

	if(sprite != null):
		if(direction == Vector2.LEFT):
			sprite.frame_coords.y = 1;
		elif(direction == Vector2.RIGHT):
			sprite.frame_coords.y = 2;
		else:
			sprite.frame_coords.y = 0;

	if(position.x > max_x_pos):
		position.x = max_x_pos;
		direction = Vector2.ZERO;
		sprite.frame_coords.y = 1;
	elif(position.x < 0):
		position.x = 0;
		direction = Vector2.ZERO;
		sprite.frame_coords.y = 2;
	if(position.y > 700):
		on_hp_zero();
