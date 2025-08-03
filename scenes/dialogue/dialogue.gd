extends CanvasLayer

var current_dialogue: DialogueRes = null


func _process(delta):
	pass


func show_dialogue(res: DialogueRes) -> void:
	current_dialogue = res


func hide_dialogue() -> void:
	current_dialogue = null
