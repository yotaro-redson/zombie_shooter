extends Resource

class_name Weapon_Resource

@export var Weapon_Name : String
@export var Activate_ani : String
@export var Shoot_ani:String
@export var Deactivate_ani : String
@export var Reload_ani : String
@export var OutofAmmo_ani : String

@export var Current_Ammo : int
@export var Reserve_Ammo : int
@export var Magazine : int
@export var Max_Ammo : int

@export var Auto_Fire : bool
@export_flags("HitScan","Projectile") var Type

