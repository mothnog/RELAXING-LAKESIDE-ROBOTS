# code adapted from garbage_pile.gd

extends Node3D

@onready var sprites_parent = $Sprites
@onready var sprite_types_parent = $SpriteTypes


@export var seed: int = 0
@export var stars: int = 50
@export var radius: float = 100


var rng = RandomNumberGenerator.new()



func _ready() -> void:
	rng.seed = seed
	create_stars()


func create_stars() -> void:
	for s in sprites_parent.get_children(): s.queue_free()
	
	# compile all types of sprites it can use into an array
	var sprite_types: Array[Node3D] = []
	for s in sprite_types_parent.get_children():
		sprite_types.append(s.duplicate())
	
	for i in stars:
		# generate an up vector with radius
		var vec: Vector3 = Vector3(0, radius, 0)
		
		# apply random rotations to the vector
		var rot1 = PI*random_value()-(PI/2)
		var rot2 = TAU*random_value()
		vec = vec.rotated(Vector3.RIGHT, rot1).rotated(Vector3.UP, rot2)
		
		# add a sprite at the vector
		var sprite: AnimatedSprite3D = sprite_types[hash(random_value()) % sprite_types.size()].duplicate()
		sprite.position = vec
		sprites_parent.add_child(sprite)
		
		# rotate sprite to face outward
		# i don't really know what this code means
		sprite.transform.basis.y = vec
		sprite.transform.basis.x = -sprite.transform.basis.z.cross(vec)
		sprite.transform.basis = sprite.transform.basis.orthonormalized()
		
		# apply random perameters to sprite
		sprite.pixel_size *= lerp(0.5, 1.25, random_value())
		sprite.speed_scale = lerp(1.0, 3.0, random_value())


func random_value() -> float:
	return rng.randf()
