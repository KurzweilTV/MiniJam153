extends CharacterBody2D

# Node references
@onready var wheels: AnimatedSprite2D = $TruckWheels
@onready var brake_light: PointLight2D = $BrakeLight
@onready var main_cam: Camera2D = $Camera2D
@onready var magnet_cam: Camera2D = $TruckBody/Crane/Magnet/Camera2D
@onready var magnet: = $TruckBody/Crane/Magnet

# Movement variables
var max_speed: float = 100
var acceleration: float = 20
var deceleration: float = 5
var brake_force: float = 40
var accelerating: bool = false
var braking: bool = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_deploy"):
		toggle_deployment()
	if event.is_action_pressed("toggle_sonar"):
		Truck.sonar_enabled = !Truck.sonar_enabled

func toggle_deployment() -> void:
	Truck.deployed = !Truck.deployed
	if Truck.deployed: 
		braking = true 
		magnet_cam.enabled = true
		main_cam.enabled = false
	else:
		magnet_cam.enabled = false
		main_cam.enabled = true


func _physics_process(delta: float) -> void:
	handle_movement(delta)
	update_wheels_animation()

func handle_movement(delta: float) -> void:
	var direction: float = get_direction()

	apply_movement(direction, delta)
	apply_rotation_based_on_velocity()
	apply_brake_light_intensity()

	velocity.x = clamp(velocity.x, 0, max_speed)
	move_and_slide()

func get_direction() -> float:
	if accelerating:
		return 1
	elif velocity.x > 0:
		return 0
	return 0

func apply_movement(direction: float, delta: float) -> void:
	if direction != 0:
		velocity.x += direction * acceleration * delta
		set_smoke_emission(true)
	elif velocity.x > 0:
		velocity.x -= deceleration * delta
		set_smoke_emission(false)

	if braking and velocity.x > 0:
		apply_rotation(deg_to_rad(1.5), 0.2)
		velocity.x -= brake_force * delta
		set_smoke_emission(false)
		
	if Truck.deployed:
		braking = true
		velocity.x -= (brake_force * 2) * delta

func apply_rotation(rotation_deg: float, duration: float) -> void:
	var tween = create_tween()
	tween.tween_property($TruckBody, "rotation", rotation_deg, duration)

func set_smoke_emission(emitting: bool) -> void:
	$Smoke.emitting = emitting
	$SmokeIdle.emitting = !emitting

func apply_rotation_based_on_velocity() -> void:
	if velocity.x < 50.0 and accelerating:
		apply_rotation(deg_to_rad(-1.5), 0.2)
	else:
		apply_rotation(0, 1.0 if accelerating else 0.2)

func apply_brake_light_intensity() -> void:
	brake_light.energy = 6 if braking else 2

func update_wheels_animation() -> void:
	if velocity.x > 0:
		if not wheels.is_playing():
			wheels.play("drive")
	else:
		wheels.stop()

func _process(delta: float) -> void:
	if not Truck.deployed and Truck.engine_running:
		accelerating = Input.is_action_pressed("accelerate")
		braking = Input.is_action_pressed("brake")
	else:
		accelerating = false
		braking = false
		
	handle_fuel_usage()
	toggle_sonar()
	check_engine()

func handle_fuel_usage():
	if Truck.fuel <= 0.0: 
		if Truck.barrels > 0:
			Truck.engine_running = true
			Truck.add_fuel(Truck.barrel_fuel)
			Truck.remove_barrel()
		else:
			Truck.engine_running = false
	
	if accelerating:
		Truck.high_rpm()
	else:
		Truck.idle_rpm()
		
	if Truck.fuel < 0: Truck.fuel == 0

func adjust_particle_output():
	var p1 = $TruckWheels/SandParticles
	var p2 = $TruckWheels/SandParticles2
	
	if velocity.x < 5:
		p1.hide()
		p2.hide()
		p1.amount = 1
		p2.amount = 1
	else:
		p1.show()
		p2.show()
		
	if p1.emitting == false:
		if velocity.x > 5:
			p1.amount = velocity.x
	if p2.emitting == false:
		if velocity.x > 5:
			p2.amount = velocity.x
		
	p1.emitting = !p1.emitting
	p2.emitting = !p2.emitting

func _on_fuel_timer_timeout() -> void:
	Truck.tick_engine()

func turn_lights_on():
	$TruckBody/Headlight.enabled = true
	$TruckBody/Headlight2.enabled = true
	
func turn_lights_off():
	$TruckBody/Headlight.enabled = false
	$TruckBody/Headlight2.enabled = false

func toggle_sonar():
	var sonar_beam: RayCast2D = $Sonar/Beam
	var sonar_light = $Sonar/SonarLight
	if Truck.sonar_enabled:
		sonar_light.enabled = true
		sonar_beam.enabled = true
	else:
		sonar_light.enabled = false
		sonar_beam.enabled = false		
		

func check_engine():
	if !Truck.engine_running and Input.is_action_just_pressed("start_engine") and Truck.fuel > 0:
		Truck.engine_running = true
		Truck.battery -= 10
	
	if !Truck.engine_running:
		turn_lights_off()
		$Smoke.emitting = false
		$SmokeIdle.emitting = false
		$Sonar/SonarLight.enabled = false
		$BrakeLight.enabled = false
		Truck.batt_charge_rate = 0.0
	else:
		Truck.batt_charge_rate = 1.0
		$SmokeIdle.emitting = true
		$BrakeLight.enabled = true
		
		
