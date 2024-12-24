extends Node2D

const GRAVITY = 1200
const JUMP_POWER = 500

@onready var player : CharacterBody2D = $CharacterBody2D
@onready var attack_point : Area2D = $CharacterBody2D/AttackPoint

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
		method = Callable(self, "attack")
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

# ATTACK ACTION
func attack() -> void:
	for obstacle_area in attack_point.get_overlapping_areas():
		var obstacle = obstacle_area.get_parent().object_inst
		if obstacle.object_type == "obstacle":
			obstacle.delete_object()
		
	get_tree().create_timer(actions["attack"].debounce_length).timeout.connect(on_debounce_timeout.bind("attack"))

# TIMEOUTS
func on_debounce_timeout(action_name):
	var action = actions[action_name]
	action.debounce = false
	if action.buffer:
		action.method.call()

func on_buffer_timeout(action_name):
	var action = actions[action_name]
	action.buffer = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	if player.is_on_floor():
		if state == 1 and not actions.jump.debounce:
			state = 0
			actions.jump.amount = actions.jump.default_amount
		

func _input(event: InputEvent) -> void:
	# Loop through every action and externally handle the debounce and buffer system
	for action_name in actions.keys():
		var action = actions[action_name]
		if event.is_action_pressed(action_name):
			if action.debounce and not action.buffer:
				action.buffer = true
				get_tree().create_timer(action.debounce_length).timeout.connect(on_buffer_timeout.bind(action_name))
			elif not action.debounce:
				action.debounce = true
				action.method.call()
	

func _physics_process(delta: float) -> void:
	# Gravity
	player.velocity.y += GRAVITY * delta
	player.move_and_slide()
