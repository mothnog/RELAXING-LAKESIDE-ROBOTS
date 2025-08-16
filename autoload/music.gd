extends Node

@onready var review: AudioStreamPlayer = $Review
@onready var nighttime: AudioStreamPlayer = $Nighttime


var volume: float:
	set(value):
		AudioServer.set_bus_volume_db(2, value)
		volume = value


func play(music: AudioStreamPlayer) -> void:
	music.play()


func stop(music: AudioStreamPlayer) -> void:
	music.stop()


func stop_all() -> void:
	for music in get_children(): music.stop()


func fade_out(time: float) -> void:
	var tween = get_tree().create_tween()
	
	tween.tween_property(self, "volume", -80, time).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_IN)
	tween.tween_callback(stop_all)
	tween.tween_interval(0.1)
	tween.tween_callback(set.bind("volume", 0))


func fade_in(music: AudioStreamPlayer, time: float) -> void:
	var tween = get_tree().create_tween()
	
	volume = -60
	tween.tween_property(self, "volume", 0, time).set_trans(Tween.TRANS_EXPO).set_ease(Tween.EASE_OUT)
	
	play(music)
