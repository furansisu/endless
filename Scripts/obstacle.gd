extends Node2D

@onready var Area: Area2D = self.get_node("Area2D")

var object_inst: UniqueObject
var lifetime = 0
var scroll = true

func _ready() -> void:
	Area.body_shape_entered.connect(_on_body_enter)

func _physics_process(delta: float) -> void:
	if not object_inst: return
	if object_inst.main_node.game_start:
		if scroll:
			global_position.x -= object_inst.main_node.SCROLL_SPEED * delta
		if self:
			lifetime += delta
	if lifetime >= object_inst.max_life_time:
		object_inst.delete_object()

func _on_body_enter():
	pass
