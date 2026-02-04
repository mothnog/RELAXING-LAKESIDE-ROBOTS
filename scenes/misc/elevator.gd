extends Area3D


@export var where_i_go: Node3D
@export var enter_method_string: String

var player: Player
var player_entered: bool = false

const TRANSITION_TIME = 0.75

func _process(delta):
	if player_entered:
		if player.is_on_wall() and player.input_dir != Vector3.ZERO:
			player_entered = false
			player.disable_movement = true
			
			ScreenOverlay.fade_to_black(TRANSITION_TIME, TRANSITION_TIME/3, TRANSITION_TIME)
			
			await ScreenOverlay.fade_to_black_in
			where_i_go.call(enter_method_string, player)
			
			await ScreenOverlay.fade_to_black_out
			player.disable_movement = false



func _on_body_entered(body):
	if body is Player:
		if player == null:
			player = body
		player_entered = true


func _on_body_exited(body):
	if body is Player:
		player_entered = false
