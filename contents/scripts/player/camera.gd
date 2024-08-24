extends SpringArm3D

var global_delta : float

@export var zoom_sound : AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_input(event):
	handle_camera_rotation(event)
	handle_scroll_zoom(event)

func handle_camera_rotation(event):
	if spring_length >= 1:
		if Input.is_action_pressed("right_click"):
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			if event is InputEventMouseMotion:
				rotation.y += -event.relative.x * (global_delta * .375)
				rotation.x += -event.relative.y * (global_delta * .375)
				rotation.x = clamp(rotation.x, -PI/2, PI/3)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if event is InputEventMouseMotion:
			rotation.y += -event.relative.x * (global_delta * .375)
			rotation.x += -event.relative.y * (global_delta * .375)
			rotation.x = clamp(rotation.x, -PI/2, PI/3)

func handle_scroll_zoom(event):
	if event.is_action_pressed("scroll_up"):
		spring_length -= 1
		spring_length = clamp(spring_length, 0, 999)
		zoom_sound.play()
	if event.is_action_pressed("scroll_down"):
		spring_length += 1
		spring_length = clamp(spring_length, 0, 999)
		zoom_sound.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	global_delta = delta
