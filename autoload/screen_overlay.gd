extends CanvasLayer


var awaiting_input: bool = false
var current_overlay: Node = null
var hide_dialogue_after: bool = false

const SCRAP_GET_TIME = 3.0

enum OVERLAY {NOTE}



func _process(delta):
	if current_overlay != null and Input.is_action_just_pressed("interact"):
		current_overlay.hide()
		current_overlay = null
		if hide_dialogue_after:
			Dialogue.hide_dialogue()
			hide_dialogue_after = false


func show_scrap_get(texture: Texture2D, time: float = SCRAP_GET_TIME, dialogue: DialogueRes = null) -> void:
	Dialogue.show_dialogue(dialogue)
	hide_dialogue_after = true
	
	get_tree().paused = true


func show_overlay(name: String) -> void:
	if name == "note":
		pass
