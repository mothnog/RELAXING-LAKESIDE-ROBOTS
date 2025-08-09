extends Level


const NOTES_1_PATH = "res://resources/dialogue/notes1.tres"
const NOTES_2 = preload("res://resources/dialogue/notes2.tres")


@onready var notes_dialogue = $Dialogue/Notes


func _ready():
	Dialogue.dialogue_complete.connect(_note_dialogue_complete)



func _note_dialogue_complete(path: String) -> void:
	if path == NOTES_1_PATH:
		notes_dialogue.dialogue = NOTES_2
