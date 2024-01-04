extends Control

var todo_data = TodoData.new()
@onready var date_node = $MarginContainer/ScrollContainer/VBoxContainer/TodoDate
@onready var text_node = $MarginContainer/ScrollContainer/VBoxContainer/TodoText


func _ready():
	set_current_todo()
	verify_save_directory(Global.SAVE_DIR)


func set_current_todo():
	print("Global.current_todo: ")
	print(Global.current_todo)

	if Global.current_todo == null:
		return

	todo_data.file_name = Global.current_todo.file_name
	todo_data.text = Global.current_todo.text
	todo_data.date = Global.current_todo.date
	todo_data.done = Global.current_todo.done

	date_node.text = Global.current_todo.date
	text_node.text = Global.current_todo.text


func verify_save_directory(path: String):
	DirAccess.make_dir_absolute(path)


func gen_file_name():
	return "save" + str(Time.get_unix_time_from_datetime_string(Time.get_datetime_string_from_system())) + ".json"


func _on_save_pressed():
	if Global.current_todo == null:
		todo_data.file_name = gen_file_name()

	save_todo(todo_data.file_name)
	to_list_scene()


func save_todo(file_name):
	var file = FileAccess.open_encrypted_with_pass(Global.SAVE_DIR + file_name, FileAccess.WRITE, Global.SECURITY_KEY)

	if file == null:
		print("save error")
		print(FileAccess.get_open_error())
		return

	todo_data.date = date_node.text
	todo_data.text = text_node.text

	var save_object = {
		"file_nameid": todo_data.file_name,
		"date": todo_data.date,
		"text": todo_data.text,
		"done": todo_data.done
	}

	var json_string = JSON.stringify(save_object)
	file.store_string(json_string)
	file.close()
	Global.current_todo = null


func to_list_scene():
	get_tree().change_scene_to_file("res://StartScene.tscn")


func _on_back_pressed():
	Global.current_todo = null
	to_list_scene()

