extends Node

var current_scene: Node = null;
var player: PlayerController = null;
var level: LevelBase = null;
var ui: Node = null;
var camera: Node = null;
var audio_manager: Node = null;
var input_manager: InputManager = null;

func set_player(p: PlayerController) -> void:
	player = p;

func set_level(l: LevelBase) -> void:
	level = l;

func set_ui(u: Node) -> void:
	ui = u;

func set_camera(c: Node) -> void:
	camera = c;

func set_audio_manager(a: Node) -> void:
	audio_manager = a;

func set_input_manager(i: InputManager) -> void:
	input_manager = i;
