extends KinematicBody2D
class_name Actor

const FLOOR_NORMAL: = Vector2.UP

export var speed: = Vector2(400.0, 500.0)
export var gravity: = 3500.0
export var MaxHitPoints: = 100
export var HitPoints: = 100
export var Aggro: = false

var FacingDirection:=1 # 1 Left 2 Right

var _velocity: = Vector2.ZERO


func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta

func takeDamage(NumDamage):
	Aggro = true
	HitPoints-=NumDamage
	if HitPoints<=0:
		Dead()

func Dead():
	pass