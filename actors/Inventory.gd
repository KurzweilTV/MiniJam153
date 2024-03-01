extends Node2D

# The barrel sprite scene to instance for each collected barrel.
var barrel_scene = preload("res://scenes/barrel.tscn")

# A list to keep track of the barrel instances.
var barrels = []

# Maximum barrels the truck can carry for spacing calculation.
var max_barrels = 5

# Initial position for the first barrel.
var start_position = self.position

# Spacing between barrels.
var spacing = 10

func _ready():
	pass  # Replace with function to collect barrels if necessary.

func add_barrel():
	if barrels.size() < max_barrels:
		var barrel_instance = barrel_scene.instantiate()
		# Calculate the new barrel's position based on the number of barrels already collected.
		barrel_instance.position = start_position + Vector2((barrels.size() * (-10 - spacing)), 0)
		# Add the barrel instance as a child of the barrel container node.
		self.add_child(barrel_instance)
		barrels.append(barrel_instance)

func remove_barrel():
	print("Removing Barrel")
	if barrels.size() > 0:
		var barrel_to_remove = barrels.pop_back()
		barrel_to_remove.queue_free()
		# Optionally, update positions of remaining barrels here.
