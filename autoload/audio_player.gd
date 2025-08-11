extends Node


func play(player: AudioStreamBetter) -> AudioStreamBetter:
	var p: AudioStreamBetter = player.duplicate()
	p.finished.connect(p.queue_free)
	add_child(p)
	p.playy()
	return p 



func play_3d(player: AudioStream3DBetter) -> AudioStream3DBetter:
	var p: AudioStream3DBetter = player.duplicate()
	p.finished.connect(p.queue_free)
	add_child(p)
	p.playy()
	return p
