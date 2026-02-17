extends StairsCharacterBody3D

@export var char_model : Node3D

const SPEED = 7.0
const JUMP_VELOCITY = 14.0
var walk_finish : bool

@onready var health = $Health
@onready var hp_slider = $Control/ColorRect/VSlider

@onready var body_collision = $BodyCollision
@onready var anim_tree = $newbie/AnimationTree

@onready var spring_camera = $SpringCamera

@onready var walk_sound = $walk
@onready var jump_sound = $jump
@onready var oof_sound = $oof

@onready var respawn_timer = $RespawnTimer

func _process(_delta):
	hp_slider.value = health.health

func _physics_process(delta):
	super(delta)
	body_collision.global_rotation = char_model.global_rotation
	
	# Add the gravity.
	if !is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") && is_on_floor() && !health.has_died:
		velocity.y = JUMP_VELOCITY
		jump_sound.play()
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = direction.rotated(Vector3.UP, spring_camera.rotation.y)
	if direction && !health.has_died:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		if spring_camera.spring_length >= 0.01:
			char_model.global_rotation.y = lerp_angle(char_model.global_rotation.y, atan2(-velocity.x, -velocity.z), delta * 8)
		if !walk_finish:
			if is_on_floor():
				walk_finish = false
				walk_sound.playing = true
			else:
				walk_finish = false
				walk_sound.playing = false
		elif !is_on_floor():
			walk_finish = false
			walk_sound.playing = false
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		walk_finish = false
		walk_sound.playing = false
	
	if spring_camera.spring_length <= 0.01:
		char_model.global_rotation.y = spring_camera.global_rotation.y
	
	anim_tree.set("parameters/conditions/idle", !direction && is_on_floor())
	anim_tree.set("parameters/conditions/walk", direction && is_on_floor() && !health.has_died)
	anim_tree.set("parameters/conditions/jump", !is_on_floor())
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody3D:
			var a = Vector3(c.get_normal().x, 0, c.get_normal().z)
			c.get_collider().apply_central_impulse(-a * 1)

func walk_sound_finished():
	walk_finish = true

func _on_death():
	oof_sound.play()
	respawn_timer.start()

func _on_respawn_timer_timeout():
	Global._respawn(self)
