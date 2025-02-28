extends Node2D

@onready var Area: Area2D = self.get_node("Area2D")

var object_inst: UniqueObject
var lifetime = 0
var scroll = true

var rotation_speed = 2

func _physics_process(delta: float) -> void:
    if not object_inst: return
    if object_inst.main_node.game_start:
        if scroll:
            global_position.x -= object_inst.main_node.SCROLL_SPEED * delta
        if self:
            lifetime += delta
            rotation += rotation_speed * delta
            skew -= rotation_speed * delta
    if lifetime >= object_inst.max_life_time:
        object_inst.delete_object()
    
    var overlapping_bodies = Area.get_overlapping_bodies()
    for body in overlapping_bodies:
        if body is CharacterBody2D:
            _on_body_enter(body)

func _on_body_enter(body):
    object_inst.main_node.COINS += 1
    queue_free()
