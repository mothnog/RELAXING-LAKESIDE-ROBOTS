extends Node3D


@onready var sprite = $AnimatedSprite3D
@onready var anim = $AnimationPlayer


@export var speed_mult: float = 1

@export var path_progress: float = 0
@export var path_mirror: int = 1

@export var path_height: float = 0.5
@export var path_width: float = 2

var time: float = 0
var noise3d: NoiseTexture3D = NoiseTexture3D.new()
@export var noise_speed: float = 0.1
@export var noise_amplitude: Vector3 = Vector3(1, 0.2, 2)


var frame_reduction: int = 8
var frame: int = 0

@onready var lerp_position = sprite.position


func _ready():
	noise3d.noise = FastNoiseLite.new()
	anim.speed_scale *= speed_mult


func _process(delta):
	
	if anim.is_playing(): time += noise_speed * delta
	
	var offset = Vector3(
		noise3d.noise.get_noise_3d(time, 0, 0) * noise_amplitude.x,
		noise3d.noise.get_noise_3d(0, time, 0) * noise_amplitude.y,
		noise3d.noise.get_noise_3d(0, 0, time) * noise_amplitude.z
	)
	
	var target_position = Vector3(
		(path_progress * path_width) - (path_width/2) + offset.x,
		sin(path_mirror * TAU * path_progress) * path_height + offset.y,
		offset.z
	)
	
	lerp_position = lerp(lerp_position, target_position, 10 * delta)
	
	frame += 1
	
	if frame % frame_reduction == 0:
		sprite.position = lerp_position
	


func fly_away(time: float) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position:y", position.y + 5.5, time)
