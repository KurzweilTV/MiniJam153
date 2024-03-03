extends Sprite2D

@onready var attach_point: Marker2D = $MagRange/AttachPoint
var attracted_objects = [] # Now a list to hold multiple objects

func _on_mag_range_body_entered(body: Node2D) -> void:
	if (body.is_in_group("fuel_barrels") || body.is_in_group("scrap")) and not body in attracted_objects:
		print("Found a " + body.name)
		var random_angle_degrees = randf_range(0, 360)
		body.rotation_degrees = random_angle_degrees
		attracted_objects.append(body)

func _process(delta: float) -> void:
	for attracted_object in attracted_objects:
		attracted_object.global_position = attach_point.global_position
		if position.x > -50 and position.y < 50: # logic for collecting items
			if attracted_object.is_in_group("fuel_barrels"):
				attracted_object.queue_free()
				Truck.add_barrel()
				attracted_objects.erase(attracted_object)
			elif attracted_object.is_in_group("scrap"):
				attracted_object.queue_free()
				Truck.add_scrap()
				attracted_objects.erase(attracted_object)
