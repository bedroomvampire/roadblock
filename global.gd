extends Node

var newbie = preload("res://contents/newbie/newbie.tscn")
var sa

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _respawn(name):
	var instance = newbie.instantiate()
	
	add_child(instance)
	
	name.queue_free()
	
