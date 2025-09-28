# MicInput.gd
# Make this an Autoload (Singleton) named "MicInput" in Project Settings.
extends Node

@export var volume_threshold: float = 0.1
# The player variables are no longer needed here if the player script calls MicInput directly.
# @export var player_node_path: NodePath
# var player: Node = null

var record_effect: AudioEffectCapture 

func _ready():
	# Player node logic removed since it is handled by the player script.
	
	# Get the index of the 'Record' bus
	var record_bus_index = AudioServer.get_bus_index("Record")
	if record_bus_index == -1:
		push_warning("No 'Record' bus found! Mic input will not work.")
		return

	# Get the AudioEffectCapture from the bus (Requires AudioEffectCapture in the Editor!)
	record_effect = AudioServer.get_bus_effect(record_bus_index, 0)
	
	# Verify the correct effect was found
	if record_effect == null or not record_effect is AudioEffectCapture: 
		push_warning("No AudioEffectCapture found on 'Record' bus!")
		return
	
	# No _process(_delta) function needed

func get_volume() -> float:
	if record_effect == null:
		return 0.0

	# Get all available frames from the buffer
	var frames_available = record_effect.get_frames_available()
	var samples = record_effect.get_buffer(frames_available)
	
	if samples.size() == 0:
		return 0.0

	var max_amp = 0.0
	for s in samples:
		# PackedVector2Array samples have x (Left) and y (Right) channels
		max_amp = max(max_amp, abs(s.x), abs(s.y))
	
	# Clear the buffer after reading the samples
	record_effect.clear_buffer()
	
	return max_amp

func _exit_tree():
	pass
