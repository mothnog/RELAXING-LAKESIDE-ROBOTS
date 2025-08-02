extends Area3D
class_name Interactable

@export var require_input: bool = false

var player_colliding: bool = false

signal interacted


func _ready():
	
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	
	if ! require_input:
		body_entered.connect(_on_interaction)
		


func _process(delta):
	if require_input and player_colliding and Input.is_action_just_pressed("interact"):
		_on_interaction(null)


func _on_interaction(body) -> void:
	if body is Player or body == null:
		interacted.emit()
		print("he")


func _on_body_entered(body) -> void:
	if body is Player: player_colliding = true


func _on_body_exited(body) -> void:
	if body is Player: player_colliding = false
