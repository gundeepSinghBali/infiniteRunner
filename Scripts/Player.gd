extends KinematicBody2D

signal isDead(isDead)

var deathAnimationPlayed : bool = false

#dictionaries
var state = {
	"moving":true,
	"dead":false
}

var lane_state = {
	"middle":true,
	"left": false,
	"right": false
}

var swipe_state = {
	"left": false,
	"right": false
}



#onready var
onready var animationPlayer : AnimationPlayer = $AnimationPlayer
onready var timer = $Timer
onready var animations : AnimatedSprite = $AnimatedSprite
onready var swipeDeactivate: Timer = $swipeDeactivate
onready var camera : Camera2D = $"../Camera2D"
# normal var
var move_value =  50
var initial_position : Vector2 = Vector2.ZERO
var runDirection = Vector2.DOWN
var SPEED = 200
var button_pressed_once = false
var touchStartPosition: Vector2 = Vector2.ZERO
var touchEndPosition: Vector2 = Vector2.ZERO
# Threshold to consider as a swipe
var swipeThreshold: float = 50.0

func _ready():
	
	pass

func _physics_process(delta):
	sendIsDeadPlayer()
	positionCamera()
	if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
		printLanes()
	move_and_slide(SPEED * runDirection)
	if state.moving == true and state.dead == false:
		playAnimations()
	elif state.moving == false and state.dead == true:
		SPEED = 0
		
	handleLanes()
	
func handleLanes():
	if (Input.is_action_just_pressed("ui_left") or swipe_state.left == true) and lane_state.left == false and lane_state.middle == true:
		self.position.x = -move_value
		lane_state.middle = false
		lane_state.left = true
		print("1")
	elif (Input.is_action_just_pressed("ui_right") or swipe_state.right == true) and lane_state.right == false and lane_state.middle == true:
		self.position.x = move_value;
		lane_state.right = true
		lane_state.middle = false
		print("2")
	elif (Input.is_action_just_pressed("ui_left") or swipe_state.left == true) and lane_state.left == true:
		print("3")
	elif (Input.is_action_just_pressed("ui_right") or swipe_state.right == true) and lane_state.right == true:
		print("4")
	elif (Input.is_action_just_pressed("ui_right") or swipe_state.right == true) and lane_state.left == true:
		self.position.x = Vector2.ZERO.x
		lane_state.middle = true
		lane_state.left = false
		print("5")
	elif (Input.is_action_just_pressed("ui_left") or swipe_state.left == true) and lane_state.right == true:
		lane_state.middle = true
		lane_state.right = false
		self.position.x = Vector2.ZERO.x
		print("6")
		
func printLanes():
	print(lane_state)


func playAnimations():
	animations.play("Run")
	
func _input(event):
	if event is InputEventScreenTouch:
		if event.is_pressed():
			touchStartPosition = event.position
		else:
			touchEndPosition = event.position
			if state.dead == false:
				detectSwipeDirection()

func detectSwipeDirection():
	var swipeDistance: float = touchEndPosition.x - touchStartPosition.x

	if swipeDistance > swipeThreshold:
		# Swipe to the right
		print("Right")
		swipe_state.right = true
		swipeDeactivate.start()
	elif swipeDistance < -swipeThreshold:
		# Swipe to the left
		print("Left")
		swipe_state.left = true
		swipeDeactivate.start()
	else:
		# Not a significant swipe
		print("No Swipe")


func _on_swipeDeactivate_timeout():
	swipe_state.left = false
	swipe_state.right = false

func positionCamera():
	camera.position.y = self.position.y + 65

func sendIsDeadPlayer():
	if state.dead == true:
		animations.play("default")
		
		if deathAnimationPlayed == false:
			animationPlayer.play("deadAnimation")
			deathAnimationPlayed = true
		emit_signal("isDead", true)
