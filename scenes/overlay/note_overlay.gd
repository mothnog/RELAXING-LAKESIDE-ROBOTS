extends Control

@onready var note = $Note
@onready var arrow_indicator = $ArrowIndicator


const SCROLL_AMOUNT = 490

var accel: float = 3
var scroll_speed: float = 3.5
var scroll_vel: float = 0
var scroll_dir: int = 0


func _process(delta):
	
	if visible:
		scroll_dir = sign(Input.get_axis("forward", "backward") + Input.get_axis("cam_up", "cam_down"))
		
		if scroll_dir == 1 and note.position.y <= -SCROLL_AMOUNT:
			scroll_dir = 0
		if scroll_dir == -1 and note.position.y >= 0:
			scroll_dir = 0
		
		scroll_vel = lerp(scroll_vel, scroll_dir * scroll_speed, accel * delta)
		
		note.position.y -= scroll_vel
		
		if note.position.y <= -SCROLL_AMOUNT and arrow_indicator.visible:
			arrow_indicator.hide()
			ScreenOverlay.awaiting_input = true
	else:
		note.position.y = 0
		scroll_vel = 0
		arrow_indicator.show()
