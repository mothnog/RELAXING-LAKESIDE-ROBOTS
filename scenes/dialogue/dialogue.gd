extends CanvasLayer

@onready var textboxes = $Textboxes

var current_dialogue: DialogueRes = null

const TEXTBOX = preload("res://scenes/dialogue/textbox.tscn")

signal continue_pressed


func _process(delta):
	if current_dialogue != null and Input.is_action_just_pressed("interact"):
		continue_pressed.emit()


func show_dialogue(res: DialogueRes) -> void:
	current_dialogue = res
	
	for textbox in res.textboxes:
			_create_textbox(textbox)
			if textbox.continue_input:
				await continue_pressed
				_clear_dialogue()
	


func hide_dialogue() -> void:
	current_dialogue = null
	_clear_dialogue()


func _clear_dialogue() -> void:
	for i in textboxes.get_children(): i.queue_free()


func _create_textbox(res: TextBoxRes) -> void:
	var textbox = TEXTBOX.instantiate()
	textbox.res = res
	textboxes.add_child(textbox)
