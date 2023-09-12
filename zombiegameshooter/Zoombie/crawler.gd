extends CharacterBody3D


var health = 70


var player = null
const SPEED = 1
var state_machine
const ATTACK_RANGE = 1.5


@export var player_path := "/root/World/Map/NavigationRegion3D/Map2/Player"

@onready var nav_agent = $NavigationAgent3D
@onready var ani_tree = $AnimationTree


func _ready():
	player = get_node(player_path)
	state_machine = ani_tree.get("parameters/playback")
	
	
@warning_ignore("unused_parameter")
func _process(delta):
	velocity = Vector3.ZERO
	
	match state_machine.get_current_node():
		"crawling":
			nav_agent.set_target_position(player.global_transform.origin)
			var next_nav_point= nav_agent.get_next_path_position()
			velocity =(next_nav_point - global_transform.origin).normalized()*SPEED
			rotation.y= lerp_angle(rotation.y,atan2(-velocity.x, -velocity.z),delta * 10 )
		"crawlerBite":
			look_at(Vector3(player.global_position.x,player.global_position.y, player.global_position.z), Vector3.UP)
			
	
	ani_tree.set("parameters/conditions/attack", _target_in_range())
	ani_tree.set("parameters/conditions/run", !_target_in_range())
	ani_tree.get("parameters/playback")

	if health <=0:
		ani_tree.set("parameters/conditions/die", true)
		await get_tree().create_timer(4.0).timeout	
		queue_free()
		
	move_and_slide()

func _target_in_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE


func _on_timer_timeout():
	queue_free()
