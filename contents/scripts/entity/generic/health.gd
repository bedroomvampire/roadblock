extends Node

@export var health : float = 100
signal death
var has_died : bool

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if health <= 0.1 && !has_died:
		emit_signal("death")
		has_died = true
