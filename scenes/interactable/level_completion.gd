extends Interactable


const COMPLETION_DIALOGUE = preload("res://resources/dialogue/level_completion.tres")



func _interaction() -> void:
	if ! Levels.current_level.complete:
		Dialogue.show_dialogue(COMPLETION_DIALOGUE)



func _player_exited() -> void:
	if ! Levels.current_level.complete:
		Dialogue.hide_dialogue()
