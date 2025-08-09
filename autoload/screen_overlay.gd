extends CanvasLayer

@onready var note_overlay = $NoteOverlay

@onready var input_prompt = $InputPrompt

var awaiting_input: bool = false
var current_overlay: Node = null
var _previous_overlay: Node = null
var hide_dialogue_after: bool = false

const SCRAP_GET_TIME = 3.0

enum OVERLAY {NOTE}


signal finished



func _process(delta):
	if current_overlay != null and Input.is_action_just_pressed("interact") and note_overlay == _previous_overlay:
		hide_overlay()
	
	_previous_overlay = current_overlay


func show_scrap_get(texture: Texture2D, time: float = SCRAP_GET_TIME, dialogue: DialogueRes = null) -> void:
	Dialogue.show_dialogue(dialogue)
	hide_dialogue_after = true
	
	_overlay_things()
	
	


func show_overlay(name: String) -> void:
	
	_overlay_things()
	
	if name == "note":
		current_overlay = note_overlay
		note_overlay.show()
	
	else:
		get_tree().paused = false
		print("overlay does not exist")


func _overlay_things() -> void:
	get_tree().paused = true
	awaiting_input = true
	input_prompt.show()


func hide_overlay() -> void:
	finished.emit()
	input_prompt.hide()
	current_overlay.hide()
	current_overlay = null
	get_tree().paused = false
	if hide_dialogue_after:
		Dialogue.hide_dialogue()
		hide_dialogue_after = false
