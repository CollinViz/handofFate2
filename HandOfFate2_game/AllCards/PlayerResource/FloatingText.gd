extends Position2D

onready var tween = $Tween
var velocity = Vector2(50,-100)
var gravity = Vector2(0,1)
var mass = 200

var text:String setget _set_text,_get_text
  
func _ready():
	$Label.text = text 
	tween.interpolate_property(self,"modulate",Color(modulate.r,modulate.g,modulate.b,modulate.a),Color(modulate.r,modulate.g,modulate.b,0.0),0.3,Tween.TRANS_LINEAR,Tween.EASE_OUT,0.7)

	tween.interpolate_property(self,"scale",Vector2(0,0),Vector2(1,1),0.3,Tween.TRANS_QUART,Tween.EASE_OUT)
	tween.interpolate_property(self,"scale",Vector2(1,1),Vector2(0.4,0.4),0.1,Tween.TRANS_QUART,Tween.EASE_OUT,3)

	tween.interpolate_callback(self,5.0,"destroy")

	tween.start()

func _process(delta):
	velocity+=gravity * mass * delta
	position+=velocity*delta


func _set_text(value:String):
	text = value
	if $Label!=null:
		$Label.text =text

func _get_text()->String:
	return text #$Label.text

func destroy():
	#print("destroyed")
	queue_free()
