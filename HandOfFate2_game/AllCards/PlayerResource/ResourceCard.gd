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


# Called when the node enters the scene tree for the first time.
func _ready():
	_updateCardValue()


func _showCardText(value:String) ->void:
	CardText = value
	

func _setCurrentValue(value:int) ->void:
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
