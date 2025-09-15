extends Node

var player: PlayerController = null;
var main_scene : MainScene = null;
var level: LevelBase = null;
var ui: UIControl = null;
var camera: Node = null;
var audio_manager: Node = null;
var input_manager: InputManager = null;

func _enter_tree() -> void:
	set_process_mode(PROCESS_MODE_ALWAYS);

func set_main_scene(m: MainScene) -> void:
	main_scene = m;

func set_player(p: PlayerController) -> void:
	player = p;

func set_level(l: LevelBase) -> void:
	level = l;
	if(input_manager != null):
		input_manager.input_level_active = true;

func set_ui(u: UIControl) -> void:
	ui = u;

func set_camera(c: Node) -> void:
	camera = c;

func set_audio_manager(a: Node) -> void:
	audio_manager = a;

func set_input_manager(i: InputManager) -> void:
	input_manager = i;

func reset_level() -> void:
	if main_scene == null:
		return;
	
	main_scene.set_level(main_scene.current_level_index);
