extends CanvasLayer


var awaiting_input: bool = false

const SCRAP_GET_TIME = 3.0


func show_scrap_get(texture: Texture2D, time: float = SCRAP_GET_TIME, dialogue: DialogueRes = null) -> void:
	get_tree().paused = true
	
