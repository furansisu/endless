extends Node2D

const GRAVITY = 1500
const JUMP_POWER = 650

@onready var player : CharacterBody2D = $CharacterBody2D
@onready var attack_point : Area2D = $CharacterBody2D/AttackPoint

var combo = 0
var combo_range = 5

var time = 0
var actions = {
    "jump": {
        debounce_length = .2,
        debounce = false,
        buffer = false,
        amount = 2,
        default_amount = 2,
        method = Callable(self, "jump")
    },
    "attack": {
        debounce_length = 1,
        debounce = false,
        buffer = false,
        last_hit = time,
        method = Callable(self, "attack"),
        last_time = 0
    }
}

# JUMPING = 1
# RUNNING = 0
var state = 0

# JUMP ACTION
func jump() -> void:
    if actions.jump.amount >= 1:
        get_tree().create_timer(actions["jump"].debounce_length).timeout.connect(on_debounce_timeout.bind("jump"))
        state = 1
        player.velocity.y = -JUMP_POWER
        actions.jump.amount -= 1
        # print("JUMPS: " + str(actions.jump.amount))
    elif actions.jump.debounce:
        actions.jump.debounce = false

func _ready() -> void:
    %AnimatedSprite2D.play("default")

# ATTACK ACTION
func attack() -> void:
    var hit_an_object = false
    for obstacle_area in attack_point.get_overlapping_areas():
        var obstacle = obstacle_area.get_parent().object_inst
        if obstacle.object_type == "obstacle":
            hit_an_object = true
            obstacle.delete_object()
        
    if not hit_an_object:
        combo = 0
        get_tree().create_timer(actions["attack"].debounce_length).timeout.connect(on_debounce_timeout.bind("attack"))
    else:
        if time - actions["attack"].last_time < combo_range:
            combo += 1
        actions["attack"]["last_time"] = time
        on_debounce_timeout("attack")
    

# TIMEOUTS
func on_debounce_timeout(action_name):
    var action = actions[action_name]
    action.debounce = false
    if action.buffer:
        action.method.call()

func on_buffer_timeout(action_name):
    var action = actions[action_name]
    action.buffer = false

# PROCESSING EVENTS
func _process(delta: float) -> void:
    time += delta
    if player.is_on_floor():
        if state == 1 and not actions.jump.debounce:
            state = 0
            actions.jump.amount = actions.jump.default_amount
    if actions["attack"]["last_time"] and time - actions["attack"]["last_time"] > combo_range:
        combo = 0

func _input(event: InputEvent) -> void:
    # Find the action and externally handle the debounce and buffer system
    for action_name in actions.keys():
        var action = actions[action_name]
        if event.is_action_pressed(action_name):
            if action.debounce and not action.buffer:
                action.buffer = true
                get_tree().create_timer(action.debounce_length).timeout.connect(on_buffer_timeout.bind(action_name))
            elif not action.debounce:
                action.debounce = true
                action.method.call()
            break
    

func _physics_process(delta: float) -> void:
    # Gravity
    player.velocity.y += GRAVITY * delta
    player.move_and_slide()
