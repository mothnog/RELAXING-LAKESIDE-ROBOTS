extends CharacterBody3D
class_name Player

@onready var camera = $PlayerCamera
@onready var sprite = $AnimatedSprite3D
@onready var collision = $CollisionShape3D
@onready var footstep_sound = $FootstepSound


@export var walk_speed: float = 2.4
@export var gravity: float = 0.2

var speed: float = walk_speed

var input_dir: Vector3
var move_dir: Vector3
var move_vec: Vector3
var accel: float = 15
var reccel: float = 6


var disable_movement: bool = false

var foot_step_time: float = 0.4
var foot_step_timer: float = 0

var is_spring_jumping: bool = false
var is_spring_jump_frame: bool = false
signal landed_after_spring


func _physics_process(delta):
	
	
	# applying movement
	if ! disable_movement:
		input_dir = Vector3(
			Input.get_axis("left", "right"),
			0,
			Input.get_axis("forward", "backward")
		).normalized()
		
		move_dir = input_dir.rotated(Vector3.UP, camera.rotation.y)
		
		speed = lerp(speed, walk_speed, reccel * delta)
		
		move_vec = lerp(move_vec, move_dir * speed, accel * delta)
		
		velocity.x = move_vec.x
		velocity.z = move_vec.z
		
		
		# footstep sounds
		if input_dir != Vector3.ZERO and is_on_floor():
			foot_step_timer += delta
			if foot_step_timer >= foot_step_time:
				AudioPlayer.play(footstep_sound)
				foot_step_timer = 0
		else:
			foot_step_timer = 0
		
	else:
		velocity.x = 0
		velocity.z = 0
	
	# gravity
	velocity.y -= 0.2
	if is_on_floor():
		if velocity.y < 0: 
			velocity.y = -0.01
		
		if is_spring_jumping and ! is_spring_jump_frame:
			AudioPlayer.play(footstep_sound)
			landed_after_spring.emit()
			is_spring_jumping = false
	
	move_and_slide()
	
	# animations
	set_animations()
	
	# random stuff
	is_spring_jump_frame = false


func set_animations() -> void:
	
	# sprite flipping
	if input_dir.x != 0 and ! disable_movement:
		sprite.flip_h = sign(input_dir.x) == -1
	
	# animations
	if input_dir != Vector3.ZERO and ! disable_movement:
		sprite.play("walk")
	else:
		sprite.play("idle")


func set_trans(trans: Transform3D) -> void:
	global_transform = trans
	camera.set_rot()
