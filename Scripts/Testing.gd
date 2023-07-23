extends Node2D

var scene : PackedScene = preload("res://Scenes/Level1.tscn")
var scene1 : PackedScene = preload("res://Scenes/Level2.tscn")
var scene2 : PackedScene = preload("res://Scenes/Level3.tscn")
var scene3 : PackedScene = preload("res://Scenes/Level4.tscn")
var arrayOfScenes : Array = [scene, scene1, scene2, scene3]
onready var timer: Timer = $Timer
onready var nextPosition2dNode : Position2D = $Position2D
onready var scoreLabel : RichTextLabel = $Camera2D/Score
var addedScenes : Array
onready var player : KinematicBody2D = $Player
onready var camera: Camera2D = $Camera2D
var distancesBetweenLevelScenes : Vector2 = Vector2(0, 120)
var SCORE = 0

func _ready():
	player.connect("isDead", self, "onDead")
	addNextLevelNode()
func _physics_process(delta):
	handleReload()
	handleScore()
	printScore()

	
func addNextLevelNode():
	var ran = getRandomScene()
	print("getRandomScene()" + str(ran))
	var sceneInstance = arrayOfScenes[ran].instance()
	add_child(sceneInstance)
	sceneInstance.connect("OnbodyEntered", self, 'BodyEntered')
	sceneInstance.position = nextPosition2dNode.position
	nextPosition2dNode.position += distancesBetweenLevelScenes
				
func _on_Timer_timeout():
	addNextLevelNode()
	timer.start()

func BodyEntered(node):
	if node is KinematicBody2D:
		addNextLevelNode()

func getRandomScene()-> int:
	return randi() % (arrayOfScenes.size())

func onDead(isDead):
	pass


func _on_ReloadButton_pressed():
	get_tree().reload_current_scene()


func handleScore():
	if player.state.dead == false:
		SCORE += 1
	else:
		SCORE += 0
	
func printScore():
	scoreLabel.text = "Score : " + str(SCORE)

func handleSpeed():
	if SCORE > 1200:
		player.SPEED = player.speedState.medium
	elif SCORE > 5000:
		player.SPEED = player.speedState.high
	elif SCORE > 7000:
		player.SPEED = player.speedState.veryHigh
		
func handleReload():
	if Input.is_action_pressed('R'):
		get_tree().reload_current_scene()
