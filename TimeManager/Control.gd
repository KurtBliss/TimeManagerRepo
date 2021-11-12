extends Node

onready var textEdit = $TextEdit
onready var popupMenu = $PopupMenu
onready var colorPicker = $ColorPicker
onready var timerWindow = $WindowDialog

enum {TIMER_PREFIX, TIMER_ENDFIX, TIME_LEFT, TIMER_NODE}
var timers = []
var timer_template = {
	TIMER_PREFIX: "",
	TIMER_ENDFIX: "]",
	TIMER_NODE: null
}

func _ready():
	textEdit.grab_focus()
	textEdit.cursor_set_column(3)

func _process(delta):
	if Input.is_action_pressed("shift"):
		if Input.is_action_just_pressed("enter"):
			process_line_command()
	
	if Input.is_action_just_pressed("alt"):
#		if popupMenu.visible:
#			popupMenu.visible = false
#		else:
#			$PopupMenu.popup_centered()
		timerWindow.popup_centered()
	
	var _min = floor($Timer.time_left / 60)
	var _sec = floor($Timer.time_left - (_min * 60))
	
	$WindowDialog/CenterContainer/VBoxContainer/HBoxContainer/Label2.text = str(_min) + " : " + str(_sec)
	
	$label_timer.text = $WindowDialog/CenterContainer/VBoxContainer/HBoxContainer/Label2.text
	
	if Input.is_action_pressed("cmd"):
		if Input.is_action_just_pressed("t"):
			_on_LineEdit_text_entered("17")
		
		if Input.is_action_just_pressed("d"):
			check()

func check():
	var offset = 0
	var line = textEdit.cursor_get_line()
	var line_content =  textEdit.get_line(line)
	if line_content.find("[]") != -1:
		line_content = line_content.replace("[]", "[x]")
		offset = 1
	elif line_content.find("[x]") != -1:
		line_content = line_content.replace("[x]", "[]")
		offset = -1
	else:
		line_content = "[] " + line_content
		offset = 3
	textEdit.set_line(textEdit.cursor_get_line(), line_content)
	textEdit.update()
	textEdit.cursor_set_column(textEdit.cursor_get_column()+offset)
#
#func find():
#	var line = textEdit.cursor_get_line()
#	var line_content =  textEdit.get_line(line)
#	var var_find 
#	var lines = textEdit.get_line_count()
#	textEdit.update()
#	textEdit.cursor_set_line(var_find)	
#	textEdit.cursor_set_column(line_content.length())

	
	
func process_line_command():
	var prev_line_number = textEdit.cursor_get_line()-1
	var prev_line_string = textEdit.get_line(prev_line_number)
	var prev_line_length = textEdit.get_line(prev_line_number).length()
	textEdit.cursor_set_line(prev_line_number)
	textEdit.cursor_set_column(prev_line_length)

func _on_ColorPicker_color_changed(color):
	colorPicker.visible = false
	pass # Replace with function body.


func _on_PopupMenu_id_pressed(id):
	if id == 1: #color pick
		colorPicker.visible = true
	if id == 0: #
		timerWindow.popup_centered()
		pass

func _on_LineEdit_text_entered(new_text):
	$Timer.start(float(new_text)*60)
	timerWindow.visible = false

func _on_Timer_timeout():
	$AcceptDialog.popup_centered()
	$AudioStreamPlayer2D.play()

func _on_Button_pressed():
	_on_LineEdit_text_entered($WindowDialog/CenterContainer/VBoxContainer/LineEdit.text)
	

#
#	if Input.is_action_just_pressed("enter"):
#		var txt = $TextEdit.get_line($TextEdit.cursor_get_line()-1)
#		if txt == "cls":
#			$TextEdit.text = ""


#	if Input.is_action_just_pressed("cmd"):
#		$TextEdit.set_line(0, "yes")
#		$TextEdit.update()
#	if Input.is_action_just_released("cmd"):
#		$TextEdit.set_line(0, "no")
#		$TextEdit.update()
#
#
