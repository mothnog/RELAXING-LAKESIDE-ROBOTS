extends CanvasLayer

@onready var textboxes = $Textboxes
@onready var input_prompt = $InputPrompt

var current_dialogue: DialogueRes = null
var waiting_for_input: bool = false
var input_index: int = 0

const TEXTBOX = preload("res://scenes/dialogue/textbox.tscn")

signal continue_pressed
signal dialogue_complete(path: String)
signal dialogue_hidden

@onready var input_prompt_text = input_prompt.text


func _process(delta):
	if waiting_for_input:
		input_prompt.show()
		if Input.is_action_just_pressed("interact"):
			continue_pressed.emit()
			input_index += 1
	else:
		input_prompt.hide()


func show_dialogue(res: DialogueRes) -> void:
	if res != null:
		
		hide_dialogue()
		
		current_dialogue = res
		
		for i in res.textboxes.size():
			var textbox: TextBoxRes = res.textboxes[i]
			waiting_for_input = false
			_create_textbox(textbox)
			if textbox.continue_input:
				waiting_for_input = true
				
				if textbox.continue_text.is_empty():
					input_prompt.text = input_prompt_text
				else:
					input_prompt.text = "[" + textbox.continue_text + "]" 
				
				
				await continue_pressed
				
				if current_dialogue != res:
					return
				
				_clear_dialogue()
				
				if ! textbox.screen_overlay.is_empty():
					ScreenOverlay.show_overlay(textbox.screen_overlay)
					waiting_for_input = false
					await ScreenOverlay.finished
					
					if current_dialogue != res:
						return
					
				
				if i == res.textboxes.size()-1:
					hide_dialogue()
			
			# showing screen overlay if input is not required
			elif ! textbox.screen_overlay.is_empty():
				ScreenOverlay.show_overlay(textbox.screen_overlay)
		
		dialogue_complete.emit(res.resource_path)
		
	else:
		print("no dialogue assigned")


func hide_dialogue() -> void:
	current_dialogue = null
	waiting_for_input = false
	input_index = 0
	_clear_dialogue()
	dialogue_hidden.emit()


func _clear_dialogue() -> void:
	for i in textboxes.get_children(): i.queue_free()


func _create_textbox(res: TextBoxRes) -> void:
	var textbox = TEXTBOX.instantiate()
	textbox.res = res
	textboxes.add_child(textbox)
