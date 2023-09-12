extends Node3D

signal Weapon_Changed
signal Update_Ammo
signal Update_weaponstack
@onready var auto_ray = $"../AutoRay"
@onready var Animation_Player = get_node("%AnimationPlayer")
var current_Weapon = null
var Weapon_Stack = [] # all weapon

var auto_damage = 9
var shot_damage = 10

@onready var ray_container = $"../RayContainer"
var weapon_indicator = 0
var next_weapon: String
enum {NULL, HITSCAN , PROJECTILE}
var weapon_list ={}
@export var  _weapon_resources : Array[Weapon_Resource]

@export var start_weapon : Array[String]

func _ready():
	initialize(start_weapon) 
	randomize()

func _input(event):
	if event.is_action_pressed("Weapon_Up"):
		weapon_indicator= min(weapon_indicator+1 , Weapon_Stack.size()-1)
		exit(Weapon_Stack[weapon_indicator])
		
	if event.is_action_pressed("Weapon_Down"):
		weapon_indicator = max(weapon_indicator-1,0)
		exit(Weapon_Stack[weapon_indicator])
	
	if event.is_action_pressed("shoot"):
		shoot()
		
		
	if event.is_action("reload"):
		reload()
		
func initialize(_start_weapons : Array):
	for weapon in _weapon_resources:
		weapon_list[weapon.Weapon_Name] = weapon
	
	for i in start_weapon:
		Weapon_Stack.push_back(i)
	current_Weapon = weapon_list[Weapon_Stack[0]]
	emit_signal("Update_weaponstack", Weapon_Stack)
	enter()

func enter():
	Animation_Player.queue(current_Weapon.Activate_ani)
	emit_signal("Weapon_Changed", current_Weapon.Weapon_Name)
	emit_signal("Update_Ammo", [current_Weapon.Current_Ammo, current_Weapon.Reserve_Ammo])

func Change_Weapon(Weapon_Name : String):
	current_Weapon = weapon_list[Weapon_Name]
	next_weapon= ""
	enter()


func exit(_next_weapon : String):
	if next_weapon != current_Weapon.Weapon_Name: 
		if Animation_Player.get_current_animation() != current_Weapon.Deactivate_ani:
			Animation_Player.play(current_Weapon.Deactivate_ani)
			next_weapon = _next_weapon


func _on_animation_player_animation_finished(anim_name):
	if anim_name == current_Weapon.Deactivate_ani:
		Change_Weapon(next_weapon)
		
	if anim_name == current_Weapon.Shoot_ani && current_Weapon.Auto_Fire == true:
		if Input.is_action_pressed("shoot"):
			shoot()
		
func shoot():
	if current_Weapon.Current_Ammo != 0:
		if !Animation_Player.is_playing():
			Animation_Player.play(current_Weapon.Shoot_ani)
			current_Weapon.Current_Ammo -= 1
			emit_signal("Update_Ammo", [current_Weapon.Current_Ammo, current_Weapon.Reserve_Ammo])
			
			match current_Weapon.Type:
				NULL:
					print("None")
				HITSCAN:
					print("Scan")
					_auto_shoot()
				PROJECTILE:
					_shot_shoot()
					print("Tile")
	else:
		reload()

func reload():
	if current_Weapon.Current_Ammo == current_Weapon.Magazine:
		return
	elif !Animation_Player.is_playing():
		if current_Weapon.Reserve_Ammo != 0:
			Animation_Player.play(current_Weapon.Reload_ani)
			var Reload_Amount = min(current_Weapon.Magazine- current_Weapon.Current_Ammo,current_Weapon.Magazine, current_Weapon.Reserve_Ammo)
			
			current_Weapon.Current_Ammo = current_Weapon.Current_Ammo + Reload_Amount
			current_Weapon.Reserve_Ammo = current_Weapon.Reserve_Ammo - Reload_Amount
			emit_signal("Update_Ammo", [current_Weapon.Current_Ammo, current_Weapon.Reserve_Ammo])
		else:
			Animation_Player.play(current_Weapon.Reload_ani)	

func _auto_shoot():
	if auto_ray.is_colliding():
		if auto_ray.get_collider().is_in_group("enemy"):
			var target = auto_ray.get_collider()
			target.health -= auto_damage
			print("Clash")
			
func _shot_shoot():
	for r in ray_container.get_children():
		if r.is_colliding():
			if r.get_collider().is_in_group("enemy"):
				var target = auto_ray.get_collider()
				target.health -= shot_damage
				print("Clash")
				


func _on_ammo_pick_up_body_entered(body):
	$"../../../Ammo".play()
	match current_Weapon.Type:
		HITSCAN:
			current_Weapon.Reserve_Ammo += 35
		PROJECTILE:
			current_Weapon.Reserve_Ammo += 10
			
	emit_signal("Update_Ammo", [current_Weapon.Current_Ammo, current_Weapon.Reserve_Ammo])
	body.queue_free()


