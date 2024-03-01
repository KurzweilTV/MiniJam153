extends CharacterBody2D

@onready var wheels: AnimatedSprite2D = $TruckWheels
@onready var brake_light: PointLight2D = $BrakeLight

# Movement variables
var max_speed: float = 100
var acceleration: float = 20 
var deceleration: float = 5 
var brake_force: float = 40

var accelerating: bool = false
var braking: bool = false 

func _physics_process(delta: float) -> void:
	var direction: float = 0 

	if accelerating:
		direction = 1
		if velocity.x < 50.0:
			var tween = create_tween()
			tween.tween_property($TruckBody, "rotation", deg_to_rad(-1.5), 0.2)
		else:
			var tween = create_tween()
			tween.tween_property($TruckBody, "rotation", 0, 1.0)
			
	elif velocity.x > 0:
		direction = 0
		var tween = create_tween()
		tween.tween_property($TruckBody, "rotation", 0, 0.2)

	# Apply acceleration or deceleration based on input
	if direction != 0:
		velocity.x += direction * acceleration * delta
		$Smoke.emitting = true
		$SmokeIdle.emitting = false
	else:
		if velocity.x > 0:
			velocity.x -= deceleration * delta
			$Smoke.emitting = false
			$SmokeIdle.emitting = true

	# Apply brake force
	if braking:
		brake_light.energy = 6
	else:
		brake_light.energy = 1
	if braking and velocity.x > 0:
		var tween = create_tween()
		tween.tween_property($TruckBody, "rotation", deg_to_rad(1.5), 0.2)
		velocity.x -= brake_force * delta
		$Smoke.emitting = false
		$SmokeIdle.emitting = true

	# top speed
	velocity.x = clamp(velocity.x, 0, max_speed)

	move_and_slide()

	# wheel animation based on the truck's velocity
	if velocity.x > 0:
		if not wheels.is_playing():
			wheels.play("drive")
	else:
		wheels.stop()
		var tween = create_tween()
		tween.tween_property($TruckBody, "rotation", 0, 0.2)

func _process(delta: float) -> void:
	accelerating = Input.is_action_pressed("accelerate")
	braking = Input.is_action_pressed("brake")

	if Input.is_action_just_pressed("debug_add_barrel"):
		$TruckBody/Inventory.add_barrel()
		print($TruckBody/Inventory.barrels)
	if Input.is_action_just_pressed("use_barrel"):
		$TruckBody/Inventory.remove_barrel()
		
	print("Speed: " + str(velocity.x))
