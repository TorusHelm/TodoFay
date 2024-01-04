extends Control


func _ready():
	load_data()


func load_data():
	var dir = DirAccess.open(Global.SAVE_DIR)

	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if !dir.current_is_dir():
				load_file(file_name)
			file_name = dir.get_next()


func load_file(file_name):
	var file_path = Global.SAVE_DIR + file_name;

	if FileAccess.file_exists(file_path):
		var file = FileAccess.open_encrypted_with_pass(file_path, FileAccess.READ, Global.SECURITY_KEY)

		if file == null:
			print("load data error")
			print(FileAccess.get_open_error())
			return

		var content = file.get_as_text()
		file.close()

		var data = JSON.parse_string(content)

		if data == null:
			printerr("Cannot parse %s as a json_string: (%s)" % [file_path, content])
			return

		create_todo(data.text, data.date, data.done, file_name)

	else:
		printerr("Connot open non-existent file at %s" % [file_path])


func create_todo(text, date, done, file_name):
	var todo_list = %TodoList

	if todo_list == null:
		return

	var current_todo = {
		"text": text,
		"date": date,
		"done": done,
		"file_name": file_name
	}

	if todo_list.get_child_count() > 0:
		var divider = HSeparator.new()
		todo_list.add_child(divider)

	var todo = VBoxContainer.new()
	todo.add_theme_constant_override("separation", 4)
	var todo_body = HBoxContainer.new()

	var todo_date = Label.new()
	todo_date.text = date
	todo.add_child(todo_date)

	var todo_text = Label.new()
	todo_text.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS
	todo_text.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	todo_text.clip_text = true
	todo_text.max_lines_visible = 1
	todo_text.text = text
	todo_body.add_child(todo_text)

	var checkbox = CheckBox.new()
	checkbox.button_pressed = done
	checkbox.connect("toggled", func(event): update_done(event, current_todo))
	todo_body.add_child(checkbox)

	var edit = Button.new()
	edit.custom_minimum_size.x = 40
	edit.custom_minimum_size.y = 40
	edit.icon = Global.ICON_EDIT
	edit.expand_icon = true
	edit.connect("pressed", func(): to_create_scene(current_todo))
	todo_body.add_child(edit)

	var remove = Button.new()
	remove.custom_minimum_size.x = 40
	remove.custom_minimum_size.y = 40
	remove.icon = Global.ICON_REMOVE
	remove.expand_icon = true
	remove.connect("pressed", func(): handle_remove_todo(current_todo))
	todo_body.add_child(remove)

	todo.add_child(todo_body)
	todo_body.connect("gui_input", func(event): _on_container_pressed(event, checkbox))
	todo_list.add_child(todo)


func handle_remove_todo(current_todo):
	var confirm = %ConfirmationDialog
	Global.current_todo = current_todo
	confirm.show()


func update_done(event, current_todo):
	var file = FileAccess.open_encrypted_with_pass(Global.SAVE_DIR + current_todo.file_name, FileAccess.WRITE, Global.SECURITY_KEY)

	if file == null:
		print("update_done error")
		print(FileAccess.get_open_error())
		return

	current_todo.done = event

	var json_string = JSON.stringify(current_todo)
	file.store_string(json_string)
	file.close()


func remove_todo():
	var dir = DirAccess.open(Global.SAVE_DIR)
	if dir.file_exists(Global.current_todo.file_name):
		dir.remove(Global.SAVE_DIR + Global.current_todo.file_name)
		Global.current_todo = null
		get_tree().reload_current_scene()


func to_create_scene(current_todo):
	Global.current_todo = current_todo
	get_tree().change_scene_to_file("res://CreateScene.tscn")


func _on_container_pressed(event, checkbox):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		checkbox.button_pressed = !checkbox.button_pressed


func _on_add_pressed():
	get_tree().change_scene_to_file("res://CreateScene.tscn")


func _on_confirmation_dialog_confirmed():
	remove_todo()
