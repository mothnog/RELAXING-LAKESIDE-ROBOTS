extends Interactable

@onready var sprite = $Sprite

@export var strength: float = 8

var spring_delay: float = 0.2


func _interaction() -> void:
	if player != null:
		sprite.frame = 0
		sprite.play("extend")
		await get_tree().create_timer(spring_delay).timeout
		player.velocity.y = strength
	else:
		print("something bad has happened")
