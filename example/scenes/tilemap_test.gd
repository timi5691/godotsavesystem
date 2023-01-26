extends TileMap
# this is very simple scene need to save
# basic you need declare var obj_name, and its value must diferent with others
@export var obj_name := "tilemap test"

# this func must delare, save system need it to know what to save
func get_save_properties() -> Dictionary:
	return {
		# require (this is 3 keys must have)
		"file_path": scene_file_path,
		"parent_path": str(get_path()).replace("/" + name, ""),
		"obj_name": obj_name,
		
		"global_position": global_position,
		"rotation_degrees": rotation_degrees,
		"scale": scale,
	}

# we must add this scene to group save

