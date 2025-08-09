extends Node
class_name Level



@export var collectable_requirement: int = 0


var completion: int = 0

var remaining_collectables: int:
	get():
		return clamp(collectable_requirement - completion, 0, collectable_requirement)

var complete: bool:
	get():
		return completion >= collectable_requirement


func _ready():
	Levels.current_level = self
