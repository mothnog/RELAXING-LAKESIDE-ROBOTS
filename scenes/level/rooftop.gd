extends Node3D

@onready var ambience = $Ambience

@onready var player_enter_transform = $PlayerEnterTransform
@export var player_exit_transform: Node3D
@export var world_env: WorldEnvironment

const ROOFTOP_ENV = preload("res://resources/env/rooftop_env.tres")
const LEVEL_ENV = preload("res://resources/env/level_env.tres")


const PLAYER_MODULATE = Color("b09fb4")

var ambience_target_pitch: float = 1
var pitch_factor: float = 8



func enter_rooftop(player: Player) -> void:
	player.sprite.modulate = PLAYER_MODULATE
	player.set_trans(player_enter_transform.global_transform)
	world_env.environment = ROOFTOP_ENV
	ambience.volume_db = -6


func exit_rooftop(player: Player) -> void:
	player.sprite.modulate = Color(1, 1, 1, 1)
	player.set_trans(player_exit_transform.global_transform)
	world_env.environment = LEVEL_ENV
	ambience.volume_db = -80



#func _process(delta):
	#if randf() < 0.005:
		#ambience_target_pitch = randf_range(0.66, 1.0)
	#ambience.pitch_scale = lerp(ambience.pitch_scale, ambience_target_pitch, pitch_factor * delta)
