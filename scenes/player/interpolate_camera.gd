extends Camera3D


@export var player: Player = null
@export var target_camera: Camera3D = null
@export var time: float = 2
@export var require_movement: bool = true
@export var current_on_start: bool = false
@export var easing: bool = true

@onready var initial_transform: Transform3D  = global_transform

var target_camera_real: Camera3D
var progress: float = 0


func _ready():
	if player == null: target_camera_real = target_camera
	else: target_camera_real = player.camera
	
	fov = target_camera_real.fov
	if current_on_start: current = true


func start() -> void:
	current = true



func _process(delta):
	if current:
		var moving: bool = Input.is_action_pressed("left") or Input.is_action_pressed("right") or Input.is_action_pressed("forward") or Input.is_action_pressed("backward")
		if (require_movement and moving) or ! require_movement:
			progress += delta
			progress = clamp(progress, 0.0, time)
			
			var progress_percent: float = progress/time
			if easing: progress_percent = -(cos(PI * progress_percent) - 1)/2
			
			global_transform = lerp(initial_transform, target_camera_real.global_transform, progress_percent)
		
		if progress == time:
			target_camera_real.current = true
			queue_free()
