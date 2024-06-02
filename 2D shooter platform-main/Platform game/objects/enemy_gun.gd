extends Sprite

onready var player = get_tree().current_scene.get_node('player')
var can_fire = true
var bullet = preload("res://objects/enemy_bulletboss.tscn")
var timer = Timer.new()
var state = "shoot"

onready var audio_player = $AudioPlayer # Adjust the path according to your scene tree structure
onready var audio_stream_player_2d = $gun/AudioStreamPlayer2D

func _ready():
	timer.wait_time = 0.8
	timer.autostart = true
	add_child(timer)

func _physics_process(delta):
	flip_v = true if player.global_position.x < global_position.x else false

	if global_position.distance_to(player.global_position) < 600:
		look_at(player.global_position)
		if can_fire:
			var bullet_instance = bullet.instance()
			bullet_instance.rotation = rotation + rand_range(-0.1, 0.1)
			bullet_instance.global_position = $muzzle.global_position
			get_parent().add_child(bullet_instance)
			can_fire = false
			yield(timer, "timeout")
			can_fire = true
	
func shoot():
	var bullet_instance = bullet.instance()
	bullet_instance.rotation = rotation + rand_range(-0.1, 0.1)
	bullet_instance.global_position = $muzzle.global_position
	audio_stream_player_2d.play() # Play the shooting sound
	get_parent().add_child(bullet_instance)
	queue_free()
