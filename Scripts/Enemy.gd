extends KinematicBody2D

onready var animatedSprite : AnimatedSprite = get_node("AnimatedSprite")
onready var player : KinematicBody2D = $".."
onready var text  = $RichTextLabel
onready var textureRect: TextureRect = $TextureRect


func _ready():
	pass

func handleAnimations():
	animatedSprite.play("run")
	if player.state.dead == true:
		text.visible = true
		textureRect.visible = true
		pass
func _physics_process(delta):
	handleAnimations()
