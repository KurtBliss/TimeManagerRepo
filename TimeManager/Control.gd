extends Node
onready var textEdit = $TextEdit
onready var timerWindow = $WindowDialog
var rmb = false
var following = false
var dragging_start_position = Vector2()
enum {TIMER_PREFIX, TIMER_ENDFIX, TIME_LEFT, TIMER_NODE}
var timers = []
var timer_template = {
	TIMER_PREFIX: "",
	TIMER_ENDFIX: "]",
	TIMER_NODE: null
}
const savelocation = "savegame.save"

func _ready():
	OS.set_borderless_window(true)
	textEdit.grab_focus()
	textEdit.cursor_set_column(3)
	load_game()

func _process(delta):
	if Input.is_action_pressed("shift"):
		if Input.is_action_just_pressed("enter"):
			process_line_command()
	if Input.is_action_just_pressed("alt"):
		timerWindow.popup_centered()
	OS.set_borderless_window(true)
	if following:
		OS.set_window_position(OS.window_position + textEdit.get_global_mouse_position() - dragging_start_position)
	var _min = floor($Timer.time_left / 60)
	var _sec = floor($Timer.time_left - (_min * 60))
	$WindowDialog/CenterContainer/VBoxContainer/HBoxContainer/Label2.text = str(_min) + " : " + str(_sec)
	$label_timer.text = $WindowDialog/CenterContainer/VBoxContainer/HBoxContainer/Label2.text
	
	if Input.is_action_pressed("cmd"):
		if Input.is_action_just_pressed("t"):
			_on_LineEdit_text_entered("17")
		
		if Input.is_action_just_pressed("d"):
			check()
	
	if Input.is_action_pressed("rmb"):
		rmb = true
	else:
		rmb = false

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

	
func process_line_command():
	var prev_line_number = textEdit.cursor_get_line()-1
	var prev_line_string = textEdit.get_line(prev_line_number)
	var prev_line_length = textEdit.get_line(prev_line_number).length()
	textEdit.cursor_set_line(prev_line_number)
	textEdit.cursor_set_column(prev_line_length)


func _on_LineEdit_text_entered(new_text):
	$Timer.start(float(new_text)*60)
	timerWindow.visible = false

func _on_Timer_timeout():
	$AcceptDialog.popup_centered()
	$AudioStreamPlayer2D.play()

func _on_Button_pressed():
	_on_LineEdit_text_entered($WindowDialog/CenterContainer/VBoxContainer/LineEdit.text)

func _input(event):
	if event is InputEventMouseButton:
		if event.get_button_index() == 2:
			following = !following
			dragging_start_position = textEdit.get_local_mouse_position()
		if rmb:
			if event.get_button_index() == BUTTON_WHEEL_UP:
				var a = OS.get_window_size()
				a.x += 5
				a.y += 5
				OS.set_window_size(a)
			if event.get_button_index() == BUTTON_WHEEL_DOWN:
				var a = OS.get_window_size()
				a.x -= 5
				a.y -= 5
				OS.set_window_size(a)
	if event is InputEventKey:
		if event.scancode == KEY_F1 and event.pressed:
			OS.set_borderless_window(!OS.get_borderless_window())


func save():
	var save_game = File.new()
	save_game.open(savelocation, File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for i in save_nodes:
		var node_data = i.call("save");
		save_game.store_line(to_json(node_data))
	save_game.store_string(textEdit.text)
	save_game.close()

# Note: This can be called from anywhere inside the tree. This function
# is path independent.
func load_game():
	var save_game = File.new()
	if not save_game.file_exists(savelocation):
		return # Error! We don't have a save to load.
	save_game.open(savelocation, File.READ)
	textEdit.text = save_game.get_as_text()
	save_game.close()

func _on_Control_tree_exiting():
	save()
	pass # Replace with function body.


