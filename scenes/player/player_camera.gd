extends Camera3D

@onready var player: Player = get_parent()
@export var raycast: RayCast3D = null

var rotate_around: float = 0
var rotation_dir: int = 0
var rotation_speed: float = 2.0
var rotation_vel: float = 0
var rotation_accel: float = 12

var look_dir: int = 0
var look_span: float = 20*(TAU/360)
var look_away_accel: float = 1
var look_return_accel: float = 5


const WALL_PADDING = 0.07 # distance from walls when colliding


var y_offset: float = 0
var p_offset: Vector3
var y_offset_ease_value: float = 3


@onready var horizontal_dist: float = position.z
@onready var height_vec: Vector3 = Vector3(0, position.y, 0)
@onready var default_x_rotation: float = rotation.x


func _ready():
	# reset player initial rotation and apply to cam rotation
	rotate_around = player.rotation.y
	player.rotation.y = 0
	


func _process(delta):
	if ! Engine.is_editor_hint():
		
		if current:
			
			# rotating around the player
			rotation_dir = Input.get_axis("cam_left", "cam_right")
			
			rotation_vel = lerp(rotation_vel, rotation_dir * rotation_speed, rotation_accel * delta)
			
			rotate_around -= rotation_vel * delta
			
			position = horizontal_dist * -Vector3.FORWARD.rotated(Vector3(0, 1, 0), rotate_around) + height_vec
			rotation.y = rotate_around
			
			
			# look up/down
			look_dir = Input.get_axis("cam_down", "cam_up")
			
			if look_dir != 0:
				rotation.x = lerp(rotation.x, default_x_rotation + (look_dir * look_span), look_away_accel * delta)
			else:
				rotation.x = lerp(rotation.x, default_x_rotation, look_return_accel * delta)
			
			
			# colliding with walls
			raycast.target_position = position - raycast.position
			
			if raycast.is_colliding():
				position = raycast.get_collision_point() - player.position + (raycast.get_collision_normal() * WALL_PADDING)
