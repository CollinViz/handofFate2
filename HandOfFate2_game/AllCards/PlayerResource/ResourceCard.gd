extends Control 
export(String, MULTILINE) var CardText := ""  setget _showCardText 
export var CurrentValue :=0 setget _setCurrentValue
export var MaxValue :=0 setget _setMaxValue
export var ShowMax :=false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var  bCardBack := $CardBack
onready var  bCardName := $CardName
onready var  bValue:Label = $Value

var flotationText = preload("res://AllCards/PlayerResource/FloatingText.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Health.visible= false
	$Gold.visible= false
	$Food.visible=false
	match CardText:
		"Gold":
			$Gold.visible= true
		"Food":
			$Food.visible = true
		"Health":
			$Health.visible = true	
	_updateCardValue()


func _showCardText(value:String) ->void:
	CardText = value
	

func _setCurrentValue(value:int) ->void:
	var diff =  value-CurrentValue
	print("Change in Value %d %d dif %d" % [CurrentValue,value,diff])
	if diff!=0:
		var newFlot = flotationText.instance()
		newFlot.position = self.rect_global_position
		newFlot.velocity = Vector2(rand_range(-50,50),-100)
		#newFlot.modulate = Vector2(rand_range(-50,50),-100)
		newFlot.text = str(diff)
		add_child(newFlot)
	CurrentValue = value
	_updateCardValue()

func _setMaxValue(value:int) -> void:
	MaxValue = value
	_updateCardValue()

func _updateCardValue() -> void:
	if bValue == null:
		return

	if ShowMax:
		bValue.text = " %d / %d" % [CurrentValue,MaxValue] 
	else:
		bValue.text = " %d" % CurrentValue
	
	bCardName.bbcode_enabled = true
	bCardName.bbcode_text = "%s" %CardText


func _on_ResourceCard_gui_input(event):
	_setCurrentValue(CurrentValue+10)


func _on_CardBack_gui_input(event):
	pass # Replace with function body.
