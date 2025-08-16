extends Control



@onready var review = $Review

@onready var stars = $Review/Stars
@onready var writing_text = $Writing/Text
@onready var writing_bad = $Writing/Text/Bad
@onready var writing_mid = $Writing/Text/Mid
@onready var writing_good = $Writing/Text/Good


const DIALOGUE = preload("res://resources/dialogue/review.tres")

var editing_rating: bool = false
var rating: float = 2.5




func _ready():
	review.hide()
	for i in writing_text.get_children(): i.hide()
	
	await ScreenOverlay.finished
	
	Dialogue.show_dialogue(DIALOGUE)
	Dialogue.dialogue_complete.connect(_on_dialogue_complete)



func _process(delta):
	if editing_rating:
		if Input.is_action_just_pressed("left") or Input.is_action_just_pressed("cam_left"):
			if rating > 0:
				rating -= 0.5
				stars.get_child(floor(rating)).frame -= 1
		if Input.is_action_just_pressed("right") or Input.is_action_just_pressed("cam_right"):
			if rating < 5:
				stars.get_child(floor(rating)).frame += 1
				rating += 0.5
		
		if Input.is_action_just_pressed("interact"):
			# Continue
			editing_rating = false
			await get_tree().create_timer(1.5).timeout
			review.hide()
			
			if rating <= 1.5: writing_bad.show()
			elif rating <= 3.5: writing_mid.show()
			else: writing_good.show()


func _on_dialogue_complete(path: String) -> void:
	await get_tree().process_frame
	review.show()
	editing_rating = true
