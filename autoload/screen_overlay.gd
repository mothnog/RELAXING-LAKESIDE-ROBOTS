extends CanvasLayer

@onready var note_overlay = $NoteOverlay
@onready var fade_color_rect = $FadeColorRect
@onready var scrap_overlay = $Scrap
@onready var scrap_sprite = $Scrap/ScrapSprite

@onready var input_prompt = $InputPrompt

var awaiting_input: bool = false
var current_overlay: Node = null
var _previous_overlay: Node = null
var hide_dialogue_after: bool = false


const SCRAP_GET_TIME = 3.0
enum OVERLAY {NOTE}


signal finished

signal fade_to_black_in
signal fade_to_black_out


func _ready():
	for i in get_children():
		i.hide()



func _process(delta):
	if current_overlay != null and Input.is_action_just_pressed("interact") and note_overlay == _previous_overlay:
		hide_overlay()
	
	_previous_overlay = current_overlay


func show_scrap_get(frame: int, time: float = SCRAP_GET_TIME, dialogue_path: String = "") -> void:
	if ! dialogue_path.is_empty():
		Dialogue.show_dialogue(load(dialogue_path))
		awaiting_input = true
	
	hide_dialogue_after = true
	
	current_overlay = scrap_overlay
	scrap_sprite.frame = frame
	scrap_overlay.show()
	
	
	_overlay_things(time, false)


func show_overlay(name: String) -> void:
	
	_overlay_things()
	
	if name == "note":
		current_overlay = note_overlay
		note_overlay.show()
	
	else:
		get_tree().paused = false
		print("overlay does not exist")


func _overlay_things(time: float = 0, pause: bool = true) -> void:
	if pause: get_tree().paused = true
	if time == 0:
		awaiting_input = true
		input_prompt.show()
	else:
		await get_tree().create_timer(time).timeout
		hide_overlay()


func hide_overlay() -> void:
	finished.emit()
	input_prompt.hide()
	current_overlay.hide()
	current_overlay = null
	get_tree().paused = false
	if hide_dialogue_after:
		Dialogue.hide_dialogue()
		hide_dialogue_after = false


func fade_to_black(in_time: float, hold_time: float, out_time: float) -> void:
	var tween = get_tree().create_tween()
	
	fade_color_rect.color.a = 0
	fade_color_rect.show()
	
	tween.tween_property(fade_color_rect, "color:a", 1, in_time)
	tween.tween_callback(fade_to_black_in.emit)
	tween.tween_interval(hold_time)
	tween.tween_callback(fade_to_black_out.emit)
	tween.tween_property(fade_color_rect, "color:a", 0, in_time)
	tween.tween_callback(finished.emit)
	tween.tween_callback(fade_color_rect.hide)
