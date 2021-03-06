extends Control

export var CardList :=["ForestAmbush","AFriendInNeed","FindingForestFolk","TheLeader"] setget _updateCardList
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal PlayerPawnStart(node)
signal PlayerPawnMoveTo(node)

onready var bInfoCard := $Card
var boardLayout:Array=[]
var ActiveCardsLookup:Array=[]
var _row_length=4
# Called when the node enters the scene tree for the first time.
func _ready():
	_updateCardList(CardList)


func _updateCardList(value:Array) ->void:
	if bInfoCard ==null:
		return
	CardList = value
	if CardList.size()==0:
		return
	clearBoard()
	boardLayout = getCardLayout()
	var idx = 0
	var pos = 0
	var StartingNode:Node = null
	for ch in self.get_children():
		if ch.name.count("Line")>0:
			print("Node Name %s" %ch.name)
			if ch.get_child_count()>1:
				for cx in ch.get_children():
					if cx.has_method("_on_Card_gui_input"):
						cx.IndexPos = idx
						ActiveCardsLookup.push_back(cx)
						cx.CardFace=true
						if boardLayout[idx]=='X' or boardLayout[idx]=='S' or boardLayout[idx]=='E':
							cx.CardType= CardList[pos]
							pos+=1
							cx.ActiveIndexPos = idx
							cx.visible = true
							if boardLayout[idx]=='S':
								StartingNode = cx
								
						else:
							cx.visible = false
							cx.CardType= ""
							cx.ActiveIndexPos = -1
						
						idx+=1
	
	if StartingNode!=null:
		_setStartingPos(StartingNode)

func _setStartingPos(cx):
	#Move Player to start 
	emit_signal("PlayerPawnStart",cx)
	cx.CardFace=false
	$Card.CardType= cx.CardType
	_activeCard(cx.ActiveIndexPos)

func _activeCard(child_index:int)->void:
	var x = int(child_index / _row_length)
	var y = int(child_index % _row_length)
	# print("Y %d Y %d"%[x,y])
	for ch in self.get_children():
		if ch.get_child_count()>1:
			for cx in ch.get_children():
				if cx.has_method("_on_Card_gui_input"):
					cx.CardSelect = false

	var searchGrid :=[[0,-1],[1,0],[-1,0],[0,1]]
	for posSearch in searchGrid:
		if posSearch[0] + x >=0 and y + posSearch[1]>=0 and posSearch[0] + x<=3 and y + posSearch[1]<=3:
			var tmpIdx = (posSearch[0] + x)*_row_length+(y + posSearch[1])
			if boardLayout[tmpIdx]!='' and ActiveCardsLookup[tmpIdx].CardFace:
				ActiveCardsLookup[tmpIdx].CardSelect = true
				# print("index %d has a card  Card Name %s " % [tmpIdx,ActiveCardsLookup[tmpIdx].CardType])

	

func clearBoard()->void:
	if bInfoCard ==null:
		return
	 
	for ch in self.get_children():
		if ch.get_child_count()>1:
			for cx in ch.get_children():
				if cx.has_method("_on_Card_gui_input"):
					cx.visible = false


func getCardLayout()->Array:
	if CardList.size()==4:
		return ['','S','','',
				'','X','X','',
				'','','E','',
				'','','','']
	return ['','S','','',
				'','X','X','',
				'','','E','',
				'','','','']


func _on_Control_cardClick(CardType, Node):
	if CardType=="":
		return
	emit_signal("PlayerPawnMoveTo",Node)
	$Card.CardType= CardType
	_activeCard(Node.ActiveIndexPos)
