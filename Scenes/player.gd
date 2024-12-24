extends Node2D

const GRAVITY = 1200
const JUMP_POWER = 500
var player : CharacterBody2D
var jumps : int = 2
var jump_cd : bool = false
var jump_buffer : bool = false
var remaining_jumps = jumps

# JUMPING = 1
# RUNNING = 0
var state = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    player = $CharacterBody2D


func jump() -> void:
    if remaining_jumps >= 1 and not jump_cd:
        jump_cd = true
        get_tree().create_timer(0.2).timeout.connect(on_jump_cd_timeout)
        state = 1
        player.velocity.y = -JUMP_POWER
        remaining_jumps -= 1
        print("JUMPS: " + str(remaining_jumps))
    else:
        jump_buffer = true
        get_tree().create_timer(0.2).timeout.connect(on_jump_buffer_timeout)

func on_jump_cd_timeout() -> void:
    jump_cd = false
    if jump_buffer:
        print("JUMP BUFFER (AIR)")
        jump()
        jump_buffer = false

func on_jump_buffer_timeout() -> void:
    jump_buffer = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if player.is_on_floor() and state == 1:
        state = 0
        remaining_jumps = jumps 
    
func _input(event: InputEvent) -> void:
    if event.is_action_pressed("jump"):
        jump()

func _physics_process(delta: float) -> void:
    player.velocity.y += GRAVITY * delta   
    
    if player.is_on_floor():
        if jump_buffer:
            print("JUMP BUFFER (FLOOR)")
            jump()
            jump_buffer = false
     
    player.move_and_slide()
