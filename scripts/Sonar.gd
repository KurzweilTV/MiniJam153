extends Node2D

@onready var sonar_light: PointLight2D = $SonarLight
@onready var beam: RayCast2D = $Beam
var pinged = []

var can_play_sound := true

func _physics_process(_delta: float) -> void:
	var timer := $SonarTimer
	if beam.enabled and beam.is_colliding():
		var object = beam.get_collider()
		sonar_light.energy = 3

		if object and object.is_in_group("scrap"):
			sonar_light.color = Color.GREEN
			if can_play_sound:
				Audio.play("res://sounds/zap1.ogg")
				can_play_sound = false
				timer.start()  # Use your SonarTimer to control sound play rate for "scrap"
		elif object and object.is_in_group("fuel_barrels"):
			sonar_light.color = Color.DARK_ORANGE
			if can_play_sound:
				Audio.play("res://sounds/tone1.ogg")
				can_play_sound = false
				timer.start()  # Use your SonarTimer to control sound play rate for "fuel_barrels"
		# Additional groups can be checked here if needed
	else:
		sonar_light.energy = 0.5
		# Stop sound if it's playing and no collision is detected
		if Audio.is_playing("res://sounds/zap1.ogg") or Audio.is_playing("res://sounds/tone1.ogg"):
			Audio.stop("res://sounds/zap1.ogg")
			Audio.stop("res://sounds/tone1.ogg")
			timer.stop()

	# Reset can_play_sound flag when timer stops
	if timer.is_stopped():
		can_play_sound = true

	

func _on_sonar_timer_timeout() -> void:
	print("Ping")
	Audio.play("res://sounds/zap1.ogg")
