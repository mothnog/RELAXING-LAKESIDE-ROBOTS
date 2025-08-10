extends CharacterBody3D
class_name Player

@onready var camera = $PlayerCamera
@onready var sprite = $AnimatedSprite3D
@onready var collision = $CollisionShape3D


@export var speed: float = 2.4
@export var gravity: float = 0.2


var input_dir: Vector3
var move_dir: Vector3
var move_vec: Vector3
var accel: float = 15

var disable_movement: bool = false



func _physics_process(delta):
	
	
	# applying movement
	if ! disable_movement:
		input_dir = Vector3(
			Input.get_axis("left", "right"),
			0,
			Input.get_axis("forward", "backward")
		).normalized()
		
		move_dir = input_dir.rotated(Vector3.UP, camera.rotation.y)
		
		move_vec = lerp(move_vec, move_dir * speed, accel * delta)
		
		velocity.x = move_vec.x
		velocity.z = move_vec.z
	else:
		velocity.x = 0
		velocity.z = 0
	
	# gravity
	velocity.y -= 0.2
	if is_on_floor():
		if velocity.y < 0: 
			velocity.y = -0.01
	
	move_and_slide()
	
	# animations
	set_animations()


func set_animations() -> void:
	if input_dir != Vector3.ZERO:
		sprite.play("walk")
	else:
		sprite.play("idle")
