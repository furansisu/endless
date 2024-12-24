extends Path2D

@onready var PathFollow = $PathFollow2D
var Speed = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	PathFollow.progress_ratio += delta * Speed
