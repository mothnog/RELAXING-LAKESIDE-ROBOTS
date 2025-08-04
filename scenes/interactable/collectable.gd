extends Interactable
class_name Collectable


@onready var sprite = $Sprite3D
#@onready var collision = $CollisionShape3D


@export var texture: Texture2D
@export var sprite_scale: float = 1



func _ready():
	super()
	
	if texture != null: sprite.texture = texture
	sprite.scale = Vector3.ONE * sprite_scale



#func _player_entered() -> void:
	#pass
#
#
#func _player_exited() -> void:
	#pass


func _interaction() -> void:
	
	# add to level completion
	
	queue_free()
	
