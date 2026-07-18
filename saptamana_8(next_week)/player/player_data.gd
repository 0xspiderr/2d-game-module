extends Node

var plants: Dictionary[String, int] = {
	"carrot": 0,
}

func add_plant(plant_name: String) -> void:
	if not plants.has(plant_name):
		print("%s doesn't exist in the plants dictionary" % plant_name)
		return
	plants[plant_name] += 1
	print("avem %s %s" % [plants[plant_name], plant_name])
