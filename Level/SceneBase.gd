extends Node2D

const Enemy = preload("res://Enemy/EnemyMelee.tscn")
const Health = preload("res://PowerUps/Health.tscn")

const TILE_SIZE = 8

onready var player = $Player
onready var portal = $Portal

onready var enemies = $Enemies
onready var powerUps = $PowerUps

var roomSize = Vector2(50, 50)
var borders = Rect2(1, 1, roomSize.x, roomSize.y)
var borders_for_objects = Rect2(2,2, roomSize.x -1, roomSize.y - 1)
var starting_position = roomSize/2

onready var tileMap = $TileMap



func _ready():
	randomize()
	for child in enemies.get_children():
		enemies.remove_child(child)
	generate_level()


func generate_level():
	var walker = Walker.new(starting_position, borders)
	var map = walker.walk(64 + Global.score)
	
	# Place player in first generated room
	player.position = map.front() * TILE_SIZE
	
	var end_room = walker.get_end_room()
	
	var portal_position = get_portal_position(end_room.position)
	
	portal.global_position = portal_position
	
	var rooms = walker.get_rooms()
	walker.queue_free()
	
	for location in map:
		tileMap.set_cellv(location, -1)
	
	var object_positions = find_object_positions(rooms)
	place_objects(object_positions, portal_position)
	
	tileMap.update_bitmask_region(borders.position, borders.end)

	
func get_portal_position(pos, dir=0):
	var directions = [
		Vector2.RIGHT,
		Vector2.DOWN,
		Vector2.LEFT,
		Vector2.UP
		]	
	if not borders_for_objects.has_point(pos):
		for dir in directions:
			if borders_for_objects.has_point(pos + dir):
				pos += dir
				return pos * TILE_SIZE

	return pos * TILE_SIZE

func place_objects(object_positions, portal_position):
	for pos in object_positions:
		# Don't spawn near player or in portal
		if pos.distance_to(starting_position) < 5:
			continue
		
		# Don't spawn on outer walls
		if not borders_for_objects.has_point(pos):
			continue
		
		if randf() < 0.2 and powerUps.get_child_count() < 3:
			var healthPowerUp = Health.instance()
			healthPowerUp.position = pos * TILE_SIZE
			powerUps.add_child(healthPowerUp)
		
		var enemy = Enemy.instance()
		enemy.position = pos  * TILE_SIZE
		enemies.add_child(enemy)

func find_object_positions(rooms):
	rooms.pop_front() # Remove player room
	var positions = []
	for room in rooms:
		positions.append(room.position)
	return positions

func reload_level():
	get_tree().reload_current_scene()

func _process(delta):
	# @TODO: Add level up screen text or some shit
	
	# Refresh current scene to simulate "Next Level"
	if portal.player_detected:
		Global.score += 64
		reload_level()
	
	

