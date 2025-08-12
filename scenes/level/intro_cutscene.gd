extends Node3D

@onready var interpolate_camera = $InterpolateCamera

const INTRO = preload("res://resources/dialogue/intro.tres")
const LEVEL_1_PATH = "res://scenes/level/level_1.tscn"

func _ready():
	interpolate_camera.finished.connect(start_dialogue)
	Dialogue.dialogue_complete.connect(transition_to_level)

func start_dialogue() -> void:
	Dialogue.show_dialogue(INTRO)


func transition_to_level(path) -> void:
	ScreenOverlay.fade_to_black(2, 1, 2)
	await ScreenOverlay.fade_to_black_in
	get_tree().change_scene_to_file(LEVEL_1_PATH)
