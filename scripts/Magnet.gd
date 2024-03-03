extends Sprite2D

@onready var attach_point: Marker2D = $MagRange/AttachPoint
var attracted_object

func _on_mag_range_body_entered(body: Node2D) -> void:
	if (body.is_in_group("fuel_barrels") || body.is_in_group("scrap")) and attracted_object == null:
		print("Found a " + body.name)
		attracted_object = body
		attracted_object.rotation_degrees = 90

func _process(delta: float) -> void:
	if attracted_object != null:
		attracted_object.global_position = attach_point.global_position
		attracted_object.rotation_degrees = rotation_degrees
		if position.x > -50 and position.y < 50:
			if attracted_object.is_in_group("fuel_barrels"):
				attracted_object.queue_free()
				Truck.add_barrel()
			elif attracted_object.is_in_group("scrap"):
				attracted_object.queue_free()
				Truck.add_scrap()
				


		
