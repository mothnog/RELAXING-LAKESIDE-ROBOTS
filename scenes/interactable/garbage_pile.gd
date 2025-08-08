extends Interactable
class_name GarbagePile


@onready var sprite_types_parent = $SpriteTypes
@onready var sprites_parent = $Sprites
#@onready var collision = $CollisionShape3D
@onready var shadow = $Shadow

@export var hiding: Interactable = null
@export var hiding_collision_grace_period: float = 0.5

@export_category("Pile")
@export var seed: int = 0
@export var radius: float = 1
@export var depth: float = 0
@export var depth_modulate: Color = Color.WHITE
@export var depth_unmodulated: float = 0.5
@export var sprites: int = 5
@export var scatter_sprites: int = 5


var rng = RandomNumberGenerator.new()

# PHYSICS VARIABLES
var vel_y: float = 0
const GRAVITY_STRENGTH: float = 10
const SCATTER_STRENGTH: float = 0.07
var sprite_directions: Array[Vector3]
const LIFETIME: float = 2




func _ready():
	super()
	rng.seed = seed
	collision.shape.radius = radius
	
	# prepare the object hidden under the pile
	if hiding != null:
		hiding.position = position
		hiding.disabled = true
		hiding.hide()
	
	
	create_pile()

# CREATING THE PILE
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
		
		sprite_directions.append(vec.normalized())
		
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


func random_value() -> float:
	return rng.randf()

# PHYSICS
func _physics_process(delta):
	# Scattering after interacting
	if player_has_interacted == true:
		
		vel_y -= GRAVITY_STRENGTH * delta
		
		for i in sprites_parent.get_child_count():
			var s: Node3D = sprites_parent.get_child(i)
			var vel: Vector3 = sprite_directions[i] * SCATTER_STRENGTH + (Vector3.UP * vel_y) * delta
			s.position += vel


func _interaction() -> void:
	
	# get rid of some unneeded sprites
	for i in sprites_parent.get_child_count():
		if i > scatter_sprites:
			sprites_parent.get_child(i).queue_free()
	
	shadow.hide()
	
	# unhide hiding object
	if hiding != null:
		hiding.show()
		await get_tree().create_timer(hiding_collision_grace_period).timeout
		hiding.disabled = false
	else:
		hiding_collision_grace_period = 0
	
	
	await get_tree().create_timer(LIFETIME - hiding_collision_grace_period).timeout
	queue_free()
