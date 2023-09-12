extends CanvasLayer

@onready var CurrentWeaponLabel = $VBoxContainer/HBoxContainer/CurrentWeapon
@onready var CurrentAmmoLabel = $VBoxContainer/HBoxContainer2/CurrentAmmo
@onready var CurrentWeaponStack =$VBoxContainer/HBoxContainer3/Weapons


func _on_weapon_manager_update_ammo(Ammo):
	CurrentAmmoLabel.set_text(str(Ammo[0])+ " / "+ str(Ammo[1]))

func _on_weapon_manager_weapon_changed(Weapon_Name):
	
	CurrentWeaponLabel.set_text(Weapon_Name)
