extends Node2D

export(String, FILE) var jsonFile = "res://AllCards/Cards/carddb.json"

var AllCardData:={}
var AllCardImages:Resource
var PlayerGold:=0
var PlayerFood:=0
var PlayerHeath:=0
var PlayerHeathMax:=100
var PlayerMultiply:=0

signal CardsLoaded 
signal UpdateResource 
signal PlayerDamage 
signal PlayerMultiply 


# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	NewGame()

func NewGame():
	PlayerGold=10
	PlayerFood=5
	PlayerHeath=100
	PlayerHeathMax=100
	emit_signal("UpdateResource")

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
			if PlayerFood<=0:
				PlayerFood=0
				PlayerHeath+=-10	 
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

func takeDamage(_NumDamage,HitPoints,MaxHitPoints):
	if HitPoints<=0:
		HitPoints=0
	PlayerHeath = HitPoints
	PlayerHeathMax = MaxHitPoints
	PlayerMultiply=0
	emit_signal("PlayerDamage")
	emit_signal("PlayerMultiply")

func AddMultiply(value:int) ->void:
	PlayerMultiply+=value
	emit_signal("PlayerMultiply")