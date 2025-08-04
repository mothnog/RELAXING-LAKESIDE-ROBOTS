extends Area3D
class_name Interactable


@onready var collision: CollisionShape3D = get_node_or_null("CollisionShape3D")

@export var require_input: bool = false
@export var one_shot: bool = false
@export var disabled: bool = false

var player_colliding: bool = false
var player_has_interacted: bool = false

signal player_interacting

var player: Player


func _ready():
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	if ! require_input:
		body_entered.connect(_on_interaction)
		


func _process(delta):
	if disabled: player_colliding = false
	if collision != null: collision.set_deferred("disabled", disabled)
	
	
	if require_input and player_colliding and Input.is_action_just_pressed("interact"):
		_on_interaction(null)


func _on_interaction(body) -> void:
	if ! disabled and (body is Player or body == null) and ! (one_shot and player_has_interacted):
		player_has_interacted = true
		player_interacting.emit()
		_interaction()


func _interaction() -> void:
	# overwritten
	pass


func _on_body_entered(body) -> void:
	if body is Player:
		player = body
		_player_entered()
		player_colliding = true


func _on_body_exited(body) -> void:
	if body is Player: 
		_player_exited()
		player_colliding = false


func _player_entered() -> void:
	# overwritten
	pass


func _player_exited() -> void:
	# overwritten
	pass
