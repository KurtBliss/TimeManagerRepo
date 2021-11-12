extends Label

var hover = false

func clicked():
	if hover:
		return true
	return false

func _on_label_timer_mouse_entered():
	print("hover")
	hover = true
	pass # Replace with function body.


func _on_label_timer_mouse_exited():
	hover = false
	pass # Replace with function body.
