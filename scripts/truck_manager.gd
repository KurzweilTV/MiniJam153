extends Node

const max_fuel : float = 100.0
const max_battery : float = 100.0
const max_barrels : int = 5
const max_scrap : int = 40
const fuel_normal_burn : float = 1.0
const fuel_increased_burn : float = 4.0

var engine_running: bool = false
var deployed : bool = false
var sonar_enabled : bool = false

var barrels : int = 0
var fuel_burn_rate : float = 0.5
var batt_charge_rate : float = 0
var barrel_fuel : float = 40.0
var scrap_count : int = 0
var battery_usage : float = 0

var battery : float = 90.0
var fuel : float = 100.0

func _ready() -> void:
	reset_game()

func _process(delta: float) -> void:
	check_state()

func add_barrel():
	if barrels < max_barrels:
		Truck.barrels += 1
	if barrels > max_barrels:
		barrels = max_barrels

func add_scrap():
	scrap_count += 1

func remove_barrel():
	if Truck.barrels > 0:
		Truck.barrels -= 1

func add_fuel(amount):
	fuel += amount
	
func tick_engine():
	fuel -= fuel_burn_rate
	tick_battery()


func tick_battery():
	if sonar_enabled:
		battery_usage = 4
	else:
		battery_usage = 0
	
	var total_usage = batt_charge_rate - battery_usage
	battery += total_usage
	
func high_rpm():
	fuel_burn_rate = fuel_increased_burn
	
func idle_rpm():
	fuel_burn_rate = fuel_normal_burn

func start_game():
	var game_scene : PackedScene = preload("res://scenes/main.tscn")
	barrels = 1
	scrap_count = 0
	fuel = 100.0
	battery = 90.0
	get_tree().change_scene_to_packed(game_scene)
	

func reset_game():
	get_tree().paused = false
	deployed = false
	barrels = 1
	scrap_count = 0
	fuel = 100.0
	battery = 90.0
	get_tree().call_deferred("reload_current_scene")
	
func quit_game():
	get_tree().quit()
	
func check_state():
	if scrap_count == max_scrap:
		win_game()
	
func lose_game():
	get_tree().paused = true

func win_game():
	get_tree().paused = true
	var ui_scene = get_node("/root/Desert/Ui")
	var win_scene = preload("res://scenes/win_game.tscn")
	var you_win_instance = win_scene.instantiate()
	you_win_instance
	ui_scene.add_child(you_win_instance)


	
