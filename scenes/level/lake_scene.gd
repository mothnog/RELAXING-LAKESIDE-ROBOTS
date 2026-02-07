extends Node2D


const DIALOGUE = preload("res://resources/dialogue/lakeside.tres")

@onready var lakeside = $Lakeside
@onready var hand = $Hand
@onready var initial_hand_position = $InitialHandPosition

const TRANSITION_TIME = 3.5
const BLACK_TIME = 0.1
const HAND_TIME = 6

@onready var hand_position: Vector2 = initial_hand_position.position
@onready var hand_end_pos: Vector2 = hand.position
@onready var hand_pixel_snap: int = hand.scale.x



func _ready():
	
	lakeside.hide()
	hand.hide()
	
	if ScreenOverlay.fading:
		await ScreenOverlay.finished
	
	
	await get_tree().create_timer(BLACK_TIME).timeout
	
	ScreenOverlay.fade_to_black(TRANSITION_TIME/1.5, 0.1, TRANSITION_TIME/3, Color.BLACK, true)
	await ScreenOverlay.fade_to_black_in
	
	hand.show()
	var tween = get_tree().create_tween()
	tween.tween_property(self, "hand_position", hand_end_pos, HAND_TIME + TRANSITION_TIME/2
		).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUINT)
	
	await get_tree().create_timer(HAND_TIME).timeout
	
	
	ScreenOverlay.fade_to_black(TRANSITION_TIME/2.0, 1.0, TRANSITION_TIME/2.0, Color.BLACK, true)
	await ScreenOverlay.fade_to_black_in
	
	hand.hide()
	
	
	lakeside.show()
	
	await ScreenOverlay.finished
	
	await get_tree().create_timer(1.0).timeout
	
	Dialogue.show_dialogue(DIALOGUE)
	
	
	await Dialogue.dialogue_complete
	
	ScreenOverlay.fade_to_black(4, 1, 0.1, Color.BLACK, true)
	await ScreenOverlay.fade_to_black_out
	
	get_tree().change_scene_to_file("res://scenes/level/review_time.tscn")


func _process(delta):
	hand.position = Vector2(
		snapped(hand_position.x, hand_pixel_snap),
		snapped(hand_position.y, hand_pixel_snap)
	)
