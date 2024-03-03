extends Node2D

@onready var beam: RayCast2D = $Beam

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if beam.enabled and beam.is_colliding():
		var object = beam.get_collider()
		print("Detected a " + str(object))
