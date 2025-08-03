extends CanvasLayer

@onready var textboxes = $Textboxes
@onready var input_prompt = $InputPrompt

var current_dialogue: DialogueRes = null
var waiting_for_input: bool = false

const TEXTBOX = preload("res://scenes/dialogue/textbox.tscn")

signal continue_pressed


func _process(delta):
	if waiting_for_input:
		input_prompt.show()
		if Input.is_action_just_pressed("interact"):
			continue_pressed.emit()
	else:
		input_prompt.hide()


func show_dialogue(res: DialogueRes) -> void:
	current_dialogue = res
	
	for textbox in res.textboxes:
		waiting_for_input = false
		_create_textbox(textbox)
		if textbox.continue_input:
			waiting_for_input = true
			await continue_pressed
			_clear_dialogue()


func hide_dialogue() -> void:
	current_dialogue = null
	waiting_for_input = false
	_clear_dialogue()


func _clear_dialogue() -> void:
	for i in textboxes.get_children(): i.queue_free()


func _create_textbox(res: TextBoxRes) -> void:
	var textbox = TEXTBOX.instantiate()
	textbox.res = res
	textboxes.add_child(textbox)
