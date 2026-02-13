extends Node3D

@onready var interpolate_camera = $InterpolateCamera
@onready var arrow_indicator = $CanvasLayer/ArrowIndicator
@onready var possum_indicator = $CanvasLayer/PossumIndicator

const INTRO = preload("res://resources/dialogue/intro.tres")
const LEVEL_1_PATH = "res://scenes/level/level_1.tscn"


func _ready():
	interpolate_camera.finished.connect(start_dialogue)
	Dialogue.dialogue_complete.connect(transition_to_level)
	
	Music.play(Music.nighttime)


func _process(delta):
	possum_indicator.visible = Dialogue.current_dialogue != null and Dialogue.input_index == 0


func start_dialogue() -> void:
	arrow_indicator.hide()
	Dialogue.show_dialogue(INTRO)


func transition_to_level(path) -> void:
	ScreenOverlay.fade_to_black(2, 1, 2)
	Music.fade_out(7.5)
	await ScreenOverlay.fade_to_black_in
	get_tree().change_scene_to_file(LEVEL_1_PATH)
