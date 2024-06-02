extends Sprite

var can_fire = true
var bullet = preload("res://objects/bullet.tscn")
var state = "shoot"

func _ready():
	set_as_toplevel(true)
	
onready var audio_player = $AudioStreamPlayer2D
onready var audio_player_3_bullet = $AudioPlayer3bullet


func _physics_process(delta):
	position.x = lerp(position.x, get_parent().position.x, 0.5)
	position.y = lerp(position.y, get_parent().position.y+10, 0.5)
	var mouse_pos = get_global_mouse_position()
	look_at(mouse_pos)
	
	if Input.is_action_pressed("fire") and can_fire:
		call(state)
	
	# Stop the audio when the fire action is released
	if Input.is_action_just_released("fire"):
		audio_player.stop()
		audio_player_3_bullet.stop()
	

func shoot_spread():
	var rots = [-0.1, 0, 0.1]
	for i in range(3):
		var bullet_instance = bullet.instance()
		bullet_instance.global_position = $muzzle.global_position
		bullet_instance.rotation = rotation + rots[i]
		audio_player_3_bullet.play()
		get_parent().screen_shaker._shake(0.3, 3)
		get_parent().add_child(bullet_instance)
	can_fire = false
		

func shoot():
	var bullet_instance = bullet.instance()
	bullet_instance.rotation = rotation + rand_range(-0.1, 0.1)
	bullet_instance.global_position = $muzzle.global_position
	audio_player.play()
	get_parent().screen_shaker._shake(0.2, 2)
	get_parent().add_child(bullet_instance)
	# Play the shooting sound
	audio_player.play()
	can_fire = false

func _on_Timer_timeout():
	can_fire = true
