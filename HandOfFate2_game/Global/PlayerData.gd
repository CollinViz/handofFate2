extends Node2D

export(String, FILE) var jsonFile = "res://AllCards/Cards/carddb.json"

var AllCardData:={}
var AllCardImages:Resource
var PlayerGold:=0
var PlayerFood:=0
var PlayerHeath:=0
var PlayerHeathMax:=100

signal CardsLoaded 
signal UpdateResource 


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func LoadCardData()->void:
	print("Load Json %s" % jsonFile)
	var file = File.new()
	print("File getting ",jsonFile)
	assert(file.file_exists(jsonFile))

	file.open(jsonFile, file.READ)
	AllCardData = parse_json(file.get_as_text())
	assert(AllCardData.size() > 0)
	#load Card image_size
	AllCardImages = load("res://AllCards/Cards/Cardimg/cardImages.tres")
	emit_signal("CardsLoaded")
	 
func getCard(CardName:String):
	if AllCardData.has(CardName):
		return AllCardData[CardName]
	else:
		return {
			"img": "cardImgDefault",
			"Text": "XXX",
			"type": "XXXX",
			"ResourceType":"XX"
		  }


func ManageCardEvent(CardInfo)->bool:
	if CardInfo.has("ResourceType"):
		return _manageResource(CardInfo)
	
	return false

func _manageResource(CardInfo)->bool:
	match CardInfo.ResourceType:
		"Food":
			PlayerFood+=CardInfo.ResourceValue			 
		"Heath":
			PlayerHeath+=CardInfo.ResourceValue
			if PlayerHeath>PlayerHeathMax:
				PlayerHeath = PlayerHeathMax
		"Gold":
			PlayerGold+=CardInfo.ResourceValue
		_:
			return false
	emit_signal("UpdateResource")
	return true
