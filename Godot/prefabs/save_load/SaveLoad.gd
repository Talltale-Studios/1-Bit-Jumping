extends Node


export(int, "JSON", "INI") var file_format
export var path : String
export var file_name : String
export var section_name : String
export var properties : PoolStringArray


var properties_value : Array


func save_data():
	var current_property := 0
	var config := ConfigFile.new()
	var dir = Directory.new()
	while current_property < properties.size():
		# Finding the variable to save
		var variable = owner.get(properties[current_property])
		# Writing the variable to the file
		config.set_value(section_name, properties[current_property], variable)
		current_property += 1
	# Making sure the path exists
	if not dir.dir_exists(str("user://",path)):
		dir.make_dir_recursive(str("user://",path))
	# Saving the file
	var err = config.save(str("user://",path,"/",file_name))
	if err != OK:
		return ERR_FILE_CANT_WRITE
	current_property = 0


func load_data():
	# Used to check which property to load
	var current_property := 0
	var config := ConfigFile.new()
	var dir := Directory.new()
	if dir.dir_exists(str("user://",path)):
		var err = config.load(str("user://",path,"/",file_name))
		if err != OK:
			return ERR_FILE_CANT_OPEN
		while current_property < properties.size():
			var variable
			variable = config.get_value(section_name,properties[current_property])
			owner.set(properties[current_property],variable)
			current_property += 1
