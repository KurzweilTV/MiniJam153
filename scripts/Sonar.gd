extends Node2D

@onready var sonar_light: PointLight2D = $SonarLight
@onready var beam: RayCast2D = $Beam
var pinged = []



func _physics_process(_delta: float) -> void:
	if beam.enabled and beam.is_colliding():
		var object = beam.get_collider()
		sonar_light.energy = 3
	else:
		sonar_light.energy = .5

	
