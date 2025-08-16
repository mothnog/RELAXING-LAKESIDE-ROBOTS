extends Level


@export var start_player_at_start: bool = true

@onready var player: Player = $Player
@onready var cutscene_camera = $CutsceneCamera
@onready var bird = $Bird
@onready var robot_build_sound = $RobotBuildSound
@onready var player_start_pos = $PlayerStartPos


const BIRD_DIALOGGUE = preload("res://resources/dialogue/bird.tres")

const COMPLETE_DIALOGUE_PATH = "res://resources/dialogue/level_complete.tres"

var cutscene_interpolate_camera = InterpolateCamera.new()


func _ready():
	super()
	if start_player_at_start: player.position = player_start_pos.position
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
	ScreenOverlay.fade_to_black(2, 2, 1)
	
	await ScreenOverlay.fade_to_black_in
	
	robot_build_sound.play()
	
	await ScreenOverlay.fade_to_black_out
	
	bird.show()
	
	await ScreenOverlay.finished
	
	Dialogue.show_dialogue(BIRD_DIALOGGUE)
	
	await Dialogue.dialogue_complete
	
	# pan camera up and fade to white and bird fly away
	var end_fade_time: float = 4
	var tween = get_tree().create_tween()
	tween.tween_property(cutscene_camera, "rotation:x", 40 * TAU / 360, end_fade_time)
	
	bird.fly_away(end_fade_time)
	
	ScreenOverlay.fade_to_black(end_fade_time, 2, 1, Color.WHITE)
	
	await ScreenOverlay.fade_to_black_out
	
	get_tree().change_scene_to_file("res://scenes/level/review_time.tscn")
