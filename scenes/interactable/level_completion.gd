extends Interactable


const COMPLETION_DIALOGUE = preload("res://resources/dialogue/level_completion.tres")
const COMPLETE_DIALOGUE = preload("res://resources/dialogue/level_complete.tres")


func _ready():
	super()
	Dialogue.dialogue_complete.connect(_on_dialogue_finished)



func _interaction() -> void:
	print("yes")
	if ! Levels.current_level.complete:
		Dialogue.show_dialogue(COMPLETION_DIALOGUE)
	else:
		Dialogue.show_dialogue(COMPLETE_DIALOGUE)


func _player_exited() -> void:
	Dialogue.hide_dialogue()


func _on_dialogue_finished(path: String) -> void:
	# queue free after "complete dialogue" is finished
	if path == COMPLETE_DIALOGUE.resource_path:
		queue_free()
