extends Interactable
class_name InteractQuestion

@export var dialogue: DialogueRes



func _interaction() -> void:
	Dialogue.show_dialogue(dialogue)



func _player_exited() -> void:
	Dialogue.hide_dialogue()
