extends StaticBody2D


func _on_Area2D_body_entered(body):
	if body is KinematicBody2D:
		if body.name == 'Player':
			body.state.moving = false
			body.state.dead = true
			

