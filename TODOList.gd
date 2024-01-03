extends VBoxContainer

func create_todo(text, date, done):
	var todo = VBoxContainer.new()
	var todo_body = HBoxContainer.new()
	
	var todo_date = Label.new()
	todo_date.text = date
	todo.add_child(todo_date)

	var label = Label.new()
	label.text = text
	todo_body.add_child(label)
	
	var checkbox = CheckBox.new()
	checkbox.button_pressed = done
	todo_body.add_child(checkbox)

	todo.add_child(todo_body)
	todo_body.connect("gui_input", func(event): _on_container_pressed(event, checkbox))
	add_child(todo)
	
	return todo


func _on_container_pressed(event, checkbox):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		checkbox.button_pressed = !checkbox.button_pressed
