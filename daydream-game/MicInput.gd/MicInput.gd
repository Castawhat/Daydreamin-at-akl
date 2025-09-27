extends Node

var mic_capture : AudioEffectCapture

func _ready():
	# Create the audio capture effect
	mic_capture = AudioEffectCapture.new()
	
	# Add to the "Record" bus (you need to create it in the Audio panel)
	var idx = AudioServer.get_bus_index("Record")
	AudioServer.add_bus_effect(idx, mic_capture)

func get_volume() -> float:
	if not mic_capture:
		return 0.0
	var buffer = mic_capture.get_buffer(2048)
	if buffer.is_empty():
		return 0.0
	var sum = 0.0
	for s in buffer:
		sum += abs(s)
	return sum / buffer.size()
