@tool
extends NinePatchRect

@onready var label = $MarginContainer/Label
@onready var arrow = $Arrow
@onready var path = $Path2D
@onready var arrow_target = $ArrowTarget
@onready var portrait_sprite = $ArrowTarget/Portrait

var path_points: Array[Vector2]

var res: TextBoxRes = null


func _ready():
	if res != null:
		position = res.rect.position
		size = res.rect.size
		
		label.text = res.text
		portrait_sprite.texture = res.portrait
		portrait_sprite.scale = Vector2.ONE * res.portrait_scale
		arrow_target.position = res.portrait_offset
	
	update_curve()
	update_arrow()


func _on_resized():
	update_curve()


func _process(delta):
	if Engine.is_editor_hint():
		update_arrow()



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

func update_arrow() -> void:
	# set arrow to closest point on curve to the target
	var closest = path.curve.get_closest_point(arrow_target.position) 
	arrow.position = closest - arrow.pivot_offset
	
	# set rotation by dotting position direction vector with direction vectors between points to know which side the arrow is on
	arrow.rotation_degrees = 90
	for i in path_points.size()-1:
		var path_dir_vec: Vector2 = (path_points[i+1] - path_points[i]).normalized()
		var arrow_dir_vec: Vector2 = (path_points[i+1] - closest).normalized()
		var dot: float = path_dir_vec.dot(arrow_dir_vec)
		
		if dot == 1.0:
			# also clamp position to not go off the box edges
			# there's probably a better way to do this but cant think of it rn
			if i == 0 or i == 2:
				arrow.position.x = clamp(arrow.position.x, arrow.size.x/2 - arrow.pivot_offset.x, size.x - arrow.size.x/2 - arrow.pivot_offset.x)
			else:
				arrow.position.y = clamp(arrow.position.y, arrow.size.y/2 - arrow.pivot_offset.y, size.y - arrow.size.y/2 - arrow.pivot_offset.y)
			
			break
		else:
			arrow.rotation_degrees += 90
