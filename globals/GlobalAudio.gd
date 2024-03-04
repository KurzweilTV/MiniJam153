extends Node

var num_players = 4
var bus = "master"

var available = []  # The available players.
var queue = []  # The queue of sounds to play.

func _ready():
	# Create the pool of AudioStreamPlayer nodes.
	for i in num_players:
		var p = AudioStreamPlayer.new()
		#p.volume_db = -5.0
		#p.pitch_scale = randf_range(0.9, 1.0)
		add_child(p)
		available.append(p)
		p.finished.connect(_on_stream_finished.bind(p))
		p.bus = bus

func _on_stream_finished(stream):
	# When finished playing a stream, make the player available again.
	available.append(stream)

func play(sound_path):
	queue.append(sound_path)

func stop(sound_path):
	# First, see if the sound is in the queue and remove it.
	for i in range(queue.size()):
		if queue[i] == sound_path:
			queue.remove(i)
			return # Stop here, we found and removed the sound.

	# Next, check if the sound is actively playing.
	for player in get_children():
		if player.is_class("AudioStreamPlayer") and player.stream != null:
			if player.stream.get_path() == sound_path and player.playing:
				player.stop()  # Stop the sound immediately.
				available.append(player)  # Make the player available again.
								# Optionally, we can also remove the stream reference.
				player.stream = null
				return # Stop here, the sound was playing and was stopped.

func is_playing(sound_path) -> bool:
	for player in get_children():
		if player.is_class("AudioStreamPlayer"):
			if player.stream != null and player.stream.get_path() == sound_path and player.playing:
				return true  # The sound is currently playing.
	return false  # The sound is not playing.
	
func _process(_delta):
	# Play a queued sound if any players are available.
	if not queue.is_empty() and not available.is_empty():
		available[0].stream = load(queue.pop_front())
		available[0].play()
		available.pop_front()
