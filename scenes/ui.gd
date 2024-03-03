extends CanvasLayer

@onready var fuel_bar: ProgressBar = $ColorRect/FuelBar
@onready var battery_bar: ProgressBar = $ColorRect/BatteryBar
@onready var scrap_bar: ProgressBar = $ColorRect/ScrapBar
@onready var scrap_label: Label = $ColorRect/ScrapBar/Label

func _ready() -> void:
	fuel_bar.max_value = Truck.max_fuel
	battery_bar.max_value = Truck.max_battery
	scrap_bar.max_value = Truck.max_scrap
	
func _process(delta: float) -> void:
	fuel_bar.value = Truck.fuel
	battery_bar.value = Truck.battery
	scrap_bar.value = Truck.scrap_count
	scrap_label.text = "Scrap: " + str(int(scrap_bar.value)) + " / " + str(int(Truck.max_scrap))
	$Label.text = "Barrels: " + str(Truck.barrels)
	
func _on_button_pressed() -> void:
	Truck.reset_game()
