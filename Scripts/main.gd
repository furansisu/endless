extends Node2D

var game_start : bool = false
var scroll : float = 0
var window_size
@export var SCROLL_SPEED : float = 350

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_start = true
	print("Game start")
	window_size = get_window().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if game_start:
		scroll += SCROLL_SPEED * delta
		
		if scroll > window_size.x:
			scroll = 0
		
		$Ground.position.x = -scroll
