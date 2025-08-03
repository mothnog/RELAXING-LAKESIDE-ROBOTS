@tool
extends NinePatchRect

@onready var arrow = $Arrow
@onready var path = $Path2D
@onready var arrow_target = $ArrowTarget

var path_points: Array[Vector2]

const ARROW_EDGE_MARGIN = 5



func _ready():
	update_curve()


func _on_resized():
	update_curve()


func _process(delta):
	if Engine.is_editor_hint():
		update_arrow(arrow_target.position)



func update_curve() -> void:
	var curve = Curve2D.new()
	var end = size
	path_points = [
		Vector2(0, 0),
		Vector2(end.x, 0),
		Vector2(end.x, end.y),
		Vector2(0, end.y),
		Vector2(0, 0),
	]
	
	for p in path_points: curve.add_point(p)
	
	path.curve = curve

func update_arrow(target: Vector2) -> void:
	# set arrow to closest point on curve to the target
	var closest = path.curve.get_closest_point(target) 
	arrow.position = closest - arrow.pivot_offset
	
	# set rotation by dotting position direction vector with direction vectors between points to know which side the arrow is on
	arrow.rotation_degrees = 90
	for i in path_points.size()-1:
		var path_dir_vec: Vector2 = (path_points[i+1] - path_points[i]).normalized()
		var arrow_dir_vec: Vector2 = (path_points[i+1] - closest).normalized()
		var dot: float = path_dir_vec.dot(arrow_dir_vec)
		
		if dot == 1.0:
			break
		else:
			arrow.rotation_degrees += 90
