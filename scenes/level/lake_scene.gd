extends Node2D


const DIALOGUE = preload("res://resources/dialogue/lakeside.tres")


func _ready():
	if ScreenOverlay.fading:
		await ScreenOverlay.finished
	
	Dialogue.show_dialogue(DIALOGUE)
	
	
	await Dialogue.dialogue_complete
	
	ScreenOverlay.fade_to_black(4, 1, 1)
	await ScreenOverlay.fade_to_black_out
	
	get_tree().change_scene_to_file("res://scenes/level/review_time.tscn")
	
	
