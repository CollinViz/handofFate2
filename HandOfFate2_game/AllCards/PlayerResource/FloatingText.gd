extends Position2D

onready var tween = $Tween
var velocity = Vector2(50,-100)
var gravity = Vector2(0,1)
var mass = 200

var text:String ="ddddd" setget _set_text,_get_text
  
func _ready():
	$Label.text = text 
	get_node("Label").set("custom_colors/default_color", self.modulate)
	$Label.set("custom_colors/font_color",self.modulate)
	#$Label.custom_colors/font_color = self.modulate
	"""
	Fade from current color after 0.7 seconds
	"""
	
	tween.interpolate_property(self, "modulate", 
		Color(modulate.r, modulate.g, modulate.b, modulate.a), 
		Color(modulate.r, modulate.g, modulate.b, 0.0),
		0.3, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.7)
	
	"""
	Increase size
	After 0.6 seconds, start to shrink slightly
	"""
	
	tween.interpolate_property(self, "scale", 
		Vector2(0, 0), 
		Vector2(1.0, 1.0),
		0.3, Tween.TRANS_QUART, Tween.EASE_OUT)
	
	tween.interpolate_property(self, "scale", 
		Vector2(1.0, 1.0), 
		Vector2(0.4, 0.4),
		1.0, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.6)
	
	"""
	After 1 second, call the destroy function to
	remove the floating text from the tree
	"""
	
	tween.interpolate_callback(self, 1.0, "destroy")
	
	"""
	Start the tweens
	"""
	print("Create floating text %s" %text)
	tween.start()
#
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
