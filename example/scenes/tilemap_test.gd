extends TileMap

@export var obj_name := "tilemap test"

func get_save_properties() -> Dictionary:
	return {
		# require
		"file_path": scene_file_path,
		"parent_path": str(get_path()).replace("/" + name, ""),
		"obj_name": obj_name,
		
		"global_position": global_position,
		"rotation_degrees": rotation_degrees,
		"scale": scale,
	}


