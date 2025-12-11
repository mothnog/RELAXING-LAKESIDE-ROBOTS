extends Resource
class_name TextBoxRes

@export_group("Box")
@export var text: String
@export var rect: Rect2 = Rect2(0, 0, 600, 300)
@export var continue_input: bool = false
@export var continue_text: String = ""

@export_group("Portrait")
@export var portrait: Texture2D
@export_range(0, 8, 0.1) var portrait_scale: float = 1
@export var portrait_offset: Vector2
@export var sprite_offset: Vector2
@export var flip_h: bool = false

@export_group("Other")
@export var screen_overlay: String = ""
