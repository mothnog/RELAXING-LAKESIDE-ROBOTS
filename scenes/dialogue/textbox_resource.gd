extends Resource
class_name TextBoxRes

@export_group("Box")
@export var continue_input: bool = false
@export var text: String
@export var rect: Rect2

@export_group("Portrait")
@export var portrait: Texture2D
@export_range(0, 2, 0.1) var portrait_scale: float = 1
@export var portrait_offset: Vector2
