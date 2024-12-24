extends Node2D

@onready var coin_shapes = $CoinShapes

@export var obstacles_blueprints = []
@export var coin : PackedScene
@export var coin_blueprints = []

func _ready() -> void:
	coin_blueprints = coin_shapes.get_children()

func _process(delta: float) -> void:
	pass
