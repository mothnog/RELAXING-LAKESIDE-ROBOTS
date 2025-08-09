extends Interactable
class_name Collectable


@onready var sprite = $Sprite3D
#@onready var collision = $CollisionShape3D


@export var sprite_frame: int = 0
@export var sprite_scale: float = 1
@export var floatiness: float = 3
@export var float_speed: float = 1.5

@onready var sprite_offset: float = sprite.offset.y


func _ready():
	super()
	
	sprite.frame = sprite_frame
	sprite.scale = Vector3.ONE * sprite_scale


func _process(delta):
	super(delta)
	sprite.offset.y = sprite_offset + snapped( floatiness * sin(Time.get_ticks_msec() / 1000.0 * float_speed), 0.5)



#func _player_entered() -> void:
	#pass
#
#
#func _player_exited() -> void:
	#pass


func _interaction() -> void:
	
	# add to level completion
	print("?heh?")
	
	queue_free()
	
