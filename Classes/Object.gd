class_name UniqueObject

var object_type = "null"
var object: Node2D
var main_node: Node2D

var max_life_time = 10

func get_new_obstacle(new_parent) -> void:
	main_node = new_parent.get_parent()
	var packed_object = ObjectsDatabase.obstacles_blueprints[randi_range(0, ObjectsDatabase.obstacles_blueprints.size() - 1)]
	object = packed_object.instantiate()
	
	object.object_inst = self
	new_parent.add_child(object)
	
	randomize_length()
	
	object_type = "obstacle"

func get_new_coin(new_parent) -> void:
	main_node = new_parent.get_parent()
	var packed_object = ObjectsDatabase.coin
	object = packed_object.instantiate()
	
	object.object_inst = self
	new_parent.add_child(object)
	
	object_type = "coin"

func get_new_coin_shape(new_parent) -> void:
	main_node = new_parent.get_parent()
	var original_object = ObjectsDatabase.coin_blueprints[randi_range(0, ObjectsDatabase.coin_blueprints.size() - 1)]
	object = original_object.duplicate()
	
	for coin in object.get_children():
		coin.object_inst = self
	
	new_parent.add_child(object)
	
	object_type = "coin_shape"
	
func delete_object():
	object.queue_free()
	object_type = "null"

func randomize_length():
	object.scale = Vector2(randf_range(-4, 4), randf_range(-4, 4))
