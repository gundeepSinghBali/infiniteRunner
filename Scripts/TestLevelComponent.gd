extends Node2D

signal OnbodyEntered(node)
onready var DeleteTimer : Timer = get_node("DeleteTimer")


func _on_Area2D_body_exited(body):
	if body is KinematicBody2D:
			DeleteTimer.start()


func _on_DeleteTimer_timeout():
	self.queue_free() # Replace with function body.


func _on_Area2D_body_entered(body):
	emit_signal("OnbodyEntered", body)
