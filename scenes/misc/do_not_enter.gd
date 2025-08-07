extends Node3D

@export var separation: float = 0.2
@export var iterations: int = 5


@onready var sprite = $Sprite
@onready var sprites = $AdditionalSprites


func _ready():
	generate()


func generate() -> void:
	
	for i in sprites.get_children(): i.queue_free()
	
	for i in iterations:
		var new: AnimatedSprite3D = sprite.duplicate()
		new.position.z -= i * separation
		new.modulate.a = 1 - ( i as float / ( iterations + 1 ) )
		sprites.add_child(new)
