# MicInput.gd
extends Node

# Threshold for detecting loud sound
@export var volume_threshold: float = 0.1

# Optional: assign a player node to control
@export var player_node: NodePath

var player
var record_effect: AudioEffectRecord

func _ready():
	# If a player node is assigned, get it
	if player_node != null:
		player = get_node(player_node)
	
	# Get the index of the 'Record' bus
	var record_bus_index = AudioServer.get_bus_index('Record')
	if record_bus_index == -1:
		push_warning("No 'Record' bus found!")
		return
	
	# Get the AudioEffectRecord from the bus
	record_effect = AudioServer.get_bus_effect(record_bus_index, 0)
	if record_effect == null:
		push_warning("No AudioEffectRecord found on 'Record' bus!")
		return
	
	# Start recording
	record_effect.set_recording_active(true)

func _process(delta):
	if record_effect.is_recording_active():
		var samples = record_effect.get_buffer()
		if samples.size() > 0:
			var max_amp = 0.0
			for s in samples:
				max_amp = max(max_amp, abs(s))
			
			# Trigger player action if above threshold
			if max_amp > volume_threshold and player != null:
				# Example: call a jump() function on the player
				if "jump" in player:
					player.jump()

func _exit_tree():
	if record_effect.is_recording_active():
		record_effect.set_recording_active(false)
