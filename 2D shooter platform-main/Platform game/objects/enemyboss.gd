extends KinematicBody2D

export var speed = 100
onready var tilemap = get_tree().current_scene.get_node("TileMap")
export var flip = false
var move = Vector2(speed, 0)
export var hitpoints = 50
var dead_enemyboss = preload("res://objects/dead_enemyboss.tscn")
var bullet = preload("res://objects/enemy_bulletboss.tscn")
var state = "shoot"

onready var audio_stream_player_2d = $gun/AudioStreamPlayer2D


func dir_changed():
	flip = !flip
	$sprite.flip_h = flip
	$obj_detect.rotation_degrees = 180 if flip else 0
	move.x *= -1

func _physics_process(delta):
	if not is_on_floor():
		move.y += 10
	if !flip:
		var tile = tilemap.world_to_map(global_position + Vector2(71,81))
		check_wall(tile)
	else:
		var tile = tilemap.world_to_map(global_position + Vector2(-71,81))
		check_wall(tile)
	
	move_and_slide(move, Vector2.UP)

func check_wall(tile):
	var tile_info = tilemap.get_cellv(tile)
	if tile_info == -1:
		dir_changed()
		

func shoot():
	var bullet_instance = bullet.instance()
	bullet_instance.rotation = rotation + rand_range(-0.1, 0.1)
	bullet_instance.global_position = $muzzle.global_position
	audio_stream_player_2d.play() # Play the shooting sound
	get_parent().add_child(bullet_instance)
	queue_free()



func _on_hurtbox_area_entered(area):
	if area.is_in_group("player_bullet"):
		hitpoints -= 1
		$anim.play("flash")
		if hitpoints == 0:
			var dead = dead_enemyboss.instance()
			dead.global_position = position
			dead.rotation = area.rotation
			dead.apply_central_impulse((Vector2.RIGHT*200).rotated(dead.rotation))
			get_parent().add_child(dead)
			queue_free()

func _on_obj_detect_body_entered(body):
	pass # Replace with function body.
