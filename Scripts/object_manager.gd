extends Node2D

# Variable Size of Spawn Region
var spawn_region_size = Vector2(500, -318)
var obstacles = []

# Time
var time = 0
var last_generated = 0
var generate_delay = 1

func generate_random_pos() -> Vector2:
	return spawn_region_size * Vector2(randf(), randf())

func generate_obstacle():
	var new_obstacle = UniqueObject.new()
	new_obstacle.get_new_obstacle(self)
	new_obstacle.object.position = generate_random_pos()

func generate_coin():
	var new_coin = UniqueObject.new()
	new_coin.get_new_coin(self)
	new_coin.object.position = generate_random_pos()

func generate_coin_shape():
	var new_coin_shape = UniqueObject.new()
	new_coin_shape.get_new_coin_shape(self)
	new_coin_shape.object.position = generate_random_pos()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	
	if time - last_generated > generate_delay:
		last_generated = time
		generate_obstacle()
		generate_coin()
		generate_coin_shape()
