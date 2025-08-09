extends Resource
class_name DialogueRes


@export var textboxes: Array[TextBoxRes]

## name of screen overlay to show mid dialogue
@export var screen_overlay: String
## how many continue presses are required to show overlay
@export var overlay_index: int = 0
