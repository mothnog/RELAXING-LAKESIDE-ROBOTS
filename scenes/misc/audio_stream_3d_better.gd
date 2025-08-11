extends AudioStreamPlayer3D
class_name AudioStream3DBetter


@export var multi_stream: Array[AudioStream] = []
@export_range(0, 2) var min_pitch: float = 1
@export_range(0, 2) var max_pitch: float = 1



func playy() -> void:
	if ! multi_stream.is_empty():
		stream = multi_stream.pick_random()
	pitch_scale = randf_range(min_pitch, max_pitch)
	print(pitch_scale)
	call_deferred("play")
