extends Node

const max_fuel : float = 100.0
const max_battery : float = 100.0
const max_barrels : int = 54
const max_scrap : int = 10
const fuel_normal_burn : float = 0.5
const fuel_increased_burn : float = 4.0

var deployed : bool = false
var barrels : int = 0
var fuel_burn_rate : float = 0.5
var batt_charge_rate : float = 1.0
var barrel_fuel : float = 50.0
var scrap_count : int = 0

var battery : float = 90.0
var fuel : float = 100.0

func _ready() -> void:
	reset_game()

func add_barrel():
	if barrels < max_barrels:
		Truck.barrels += 1

func add_scrap():
	scrap_count += 1

func remove_barrel():
	if Truck.barrels > 0:
		Truck.barrels -= 1

func add_fuel(amount):
	fuel += amount
	
func tick_engine():
	fuel -= fuel_burn_rate
	battery += batt_charge_rate
	
func high_rpm():
	fuel_burn_rate = fuel_increased_burn
	
func idle_rpm():
	fuel_burn_rate = fuel_normal_burn

func reset_game():
	deployed = false
	barrels = 0
	scrap_count = 0
	fuel = 100.0
	battery = 90.0
	get_tree().reload_current_scene()
