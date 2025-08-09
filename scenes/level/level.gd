extends Node
class_name Level



@export var collectable_requirement: int = 0


func _ready():
	Levels.current_level = self
