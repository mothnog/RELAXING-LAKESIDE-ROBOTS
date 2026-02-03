extends Control



@onready var review = $Review

@onready var stars = $Review/Stars
@onready var portrait = $Writing/Portrait
@onready var writing_text = $Writing/Text
@onready var writing_bad = $Writing/Text/Bad
@onready var writing_mid = $Writing/Text/Mid
@onready var writing_good = $Writing/Text/Good
@onready var noise = $Noise
@onready var bloops = $Bloops
@onready var bloop = $Bloop
@onready var quit_prompt = $Writing/QuitPrompt


const DIALOGUE = preload("res://resources/dialogue/review.tres")

var editing_rating: bool = false
var rating: float = 2.5

var can_quit: bool = false


func _ready():
	review.hide()
	portrait.hide()
	quit_prompt.hide()
	for i in writing_text.get_children(): i.hide()
	
	
	#await ScreenOverlay.finished
	
	Dialogue.show_dialogue(DIALOGUE)
	Dialogue.dialogue_complete.connect(_on_dialogue_complete)



func _process(delta):
	if editing_rating:
		if Input.is_action_just_pressed("left") or Input.is_action_just_pressed("cam_left"):
			if rating > 0:
				AudioPlayer.play(bloop)
				rating -= 0.5
				stars.get_child(floor(rating)).frame -= 1
		if Input.is_action_just_pressed("right") or Input.is_action_just_pressed("cam_right"):
			if rating < 5:
				AudioPlayer.play(bloop)
				stars.get_child(floor(rating)).frame += 1
				rating += 0.5
		
		if Input.is_action_just_pressed("interact"):
			# Continue
			editing_rating = false
			
			# play sound and wait
			bloops.play()
			await get_tree().create_timer(3.0).timeout
			
			# show the rating
			review.hide()
			portrait.show()
			quit_prompt.show()
			var writing: Label
			if rating <= 1.5: writing = writing_bad
			elif rating <= 3.5: writing = writing_mid
			else: writing = writing_good
			writing.text = writing.text.replace("[rating]", var_to_str(rating)).replace(".0", "")
			writing.show()
			
			# music :D
			Music.fade_in(Music.review, 10)
			
			can_quit = true
	
	if can_quit and Input.is_action_just_pressed("esc"):
		get_tree().quit()


func _on_dialogue_complete(path: String) -> void:
	await get_tree().process_frame
	noise.play()
	review.show()
	editing_rating = true
