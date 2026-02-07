extends Interactable

@onready var sprite = $Sprite
@onready var spring_jump_sound = $SpringJumpSound
@onready var spring_air_sound = $SpringAirSound

@export var strength: float = 8

var spring_delay: float = 0.2
var player_speed_mult: float = 1.2



func _interaction() -> void:
	if player != null:
		sprite.frame = 0
		sprite.play("extend")
		await get_tree().create_timer(spring_delay).timeout
		
		player.position.y += 0.001
		player.velocity.y = strength
		player.is_spring_jump_frame = true
		player.is_spring_jumping = true
		player.speed *= player_speed_mult
		if ! player.landed_after_spring.is_connected(spring_air_sound.stop):
			player.landed_after_spring.connect(spring_air_sound.stop)
		
		AudioPlayer.play(spring_jump_sound)
		spring_jump_sound.play()
		spring_air_sound.play()
		
	else:
		print("something bad has happened")
