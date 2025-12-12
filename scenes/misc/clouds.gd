@tool
extends Node3D

@onready var viewport = $SubViewport
@onready var parallax = $SubViewport/Parallax2D
@onready var sprite = $SubViewport/Parallax2D/AnimatedSprite2D

var sprite_size: Vector2:
	get():
		return sprite.sprite_frames.get_frame_texture("default", 0).get_size()


var direction: Vector2 = Vector2(0, 1)
var speed: float = 5.5


func _ready():
	update_viewport_size()


func _process(delta):
	if Engine.is_editor_hint():
		update_viewport_size()
	parallax.scroll_offset += direction.normalized() * speed * delta


func update_viewport_size() -> void:
	viewport.size = sprite_size
	parallax.repeat_size = sprite_size
