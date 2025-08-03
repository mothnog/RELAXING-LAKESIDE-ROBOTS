extends Area3D

@onready var sprite_types_parent = $SpriteTypes
@onready var sprites_parent = $Sprites


@export var seed: int = 0

@export var radius: float = 1
@export var depth: float = 0
@export var depth_modulate: Color = Color.WHITE
@export var depth_unmodulated: float = 0.5
@export var sprites: int = 5


var rng = RandomNumberGenerator.new()


func _ready():
	rng.seed = seed
	
	create_pile()


func create_pile() -> void:
	
	for s in sprites_parent.get_children(): s.queue_free()
	
	# compile all types of sprites it can use into an array
	var sprite_types: Array[Node3D] = []
	for s in sprite_types_parent.get_children():
		sprite_types.append(s.duplicate())
	
	
	
	for i in sprites:
		# generate an up vector with radius + random depth applied
		var depth_amount = random_value()
		var vec: Vector3 = Vector3(0, radius - (depth * depth_amount), 0)
		
		# apply random rotations to the vector
		var rot1 = PI*random_value()-(PI/2)
		var rot2 = TAU*random_value()
		vec = vec.rotated(Vector3.RIGHT, rot1).rotated(Vector3.UP, rot2)
		
		
		
		# add a sprite at the vector
		var sprite: Node3D = sprite_types[hash(random_value()) % sprite_types.size()].duplicate()
		sprite.position = vec
		sprites_parent.add_child(sprite)
		
		# apply depth modulate
		if depth_amount > depth * depth_unmodulated:
			var modulate_amount = (depth_amount - depth_unmodulated) / (depth - depth_unmodulated)
			# these names sure are getting convoluted huh
			sprite.modulate = lerp(sprite.modulate, depth_modulate, depth_amount)
		
		# rotate sprite to face outward
		# i don't really know what this code means
		sprite.transform.basis.y = vec
		sprite.transform.basis.x = -sprite.transform.basis.z.cross(vec)
		sprite.transform.basis = sprite.transform.basis.orthonormalized()
		
		# also face up
		sprite.transform = sprite.transform.rotated(Vector3.BACK, rot2)


func random_value() -> float:
	return rng.randf()
