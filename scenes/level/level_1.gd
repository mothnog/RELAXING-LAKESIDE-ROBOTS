extends Level


@onready var player: Player = $Player
@onready var cutscene_camera = $CutsceneCamera
@onready var bird = $Bird
@onready var robot_build_sound = $RobotBuildSound


const COMPLETE_DIALOGUE_PATH = "res://resources/dialogue/level_complete.tres"

var cutscene_interpolate_camera = InterpolateCamera.new()


func _ready():
	super()
	Dialogue.dialogue_complete.connect(_on_dialogue_complete)


func _on_dialogue_complete(path: String) -> void:
	if path == COMPLETE_DIALOGUE_PATH:
		end_cutscene()


func end_cutscene() -> void:
	
	
	
	# interpolate to the cutscene camera
	cutscene_interpolate_camera.global_transform = player.camera.global_transform
	cutscene_interpolate_camera.current_on_start = true
	cutscene_interpolate_camera.target_camera = cutscene_camera
	cutscene_interpolate_camera.time = 3
	cutscene_interpolate_camera.fov = player.camera.fov
	add_child(cutscene_interpolate_camera)
	
	# disable player movement
	player.disable_movement = true
	
	
	# fade to black
	ScreenOverlay.fade_to_black(2, 2, 2)
	
	await ScreenOverlay.fade_to_black_in
	robot_build_sound.play()
	
	await ScreenOverlay.fade_to_black_out
	
	bird.show()
