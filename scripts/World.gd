extends Node3D

@onready var hit_react = $UI/HitReact
@onready var spawns = $Map/Spawns
@onready var navigation_region = $Map/NavigationRegion3D
@onready var r_spawn = $Map/RunnerSpawn
@onready var c_spawn = $Map/CrawlerSpawn

var zombie = load("res://Zoombie/z_walker.tscn")
var runner = load("res://Zoombie/Zrunner.tscn")
var crawler = load("res://Zoombie/crawler.tscn")

var instance

func _ready():
	randomize()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _get_random_child(parent_node):
	var random_id = randi() % parent_node.get_child_count()
	return parent_node.get_child(random_id)


func _on_timer_timeout():
	var spawn_point = _get_random_child(spawns).global_position
	instance = zombie.instantiate()
	instance.position = spawn_point
	navigation_region.add_child(instance)


func _on_runner_spawner_timeout():
	var spawn_point = _get_random_child(r_spawn).global_position
	instance = runner.instantiate()
	instance.position = spawn_point
	navigation_region.add_child(instance)
	


func _on_crawler_spawner_timeout():
	var spawn_point = _get_random_child(c_spawn).global_position
	instance = crawler.instantiate()
	instance.position = spawn_point
	navigation_region.add_child(instance)


func _on_player_menu():
	get_tree().change_scene_to_file("res://scences/winmenu.tscn")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_player_deathmenu():
	get_tree().change_scene_to_file("res://scences/death_screen.tscn")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
