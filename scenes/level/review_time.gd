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
	
	
	#await ScreenOverlay.finished
	await get_tree().create_timer(1.0).timeout
	
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
			
			# wait time
			await get_tree().create_timer(1.5).timeout
			
			# show the rating
			review.hide()
			var writing: Label
			if rating <= 1.5: writing = writing_bad
			elif rating <= 3.5: writing = writing_mid
			else: writing = writing_good
			writing.text = writing.text.replace("[rating]", var_to_str(rating)).replace(".0", "")
			writing.show()
			
			# music :D
			Music.fade_in(Music.review, 10)


func _on_dialogue_complete(path: String) -> void:
	await get_tree().process_frame
	review.show()
	editing_rating = true
