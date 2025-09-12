extends Label

var time_passed : float = 0.0;

func _process(delta: float) -> void:

	time_passed += delta;
	var minutes : int = int(time_passed) / 60;
	var seconds : int = int(time_passed) % 60;
	self.text = "%02d:%02d" % [minutes, seconds];
