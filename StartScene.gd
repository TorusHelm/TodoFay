extends Control


var data_list = []


func load_data():
	if not FileAccess.file_exists(Global.FILE_PATH):
		return
	
	var save = FileAccess.open(Global.FILE_PATH, FileAccess.READ)
	
	print(save)


func _ready():
	var count: int = 0
	while count < 3:
		#Global.TODO_LIST.create_todo("Помыть жопу батону\nПомыть жопу батону\nПомыть жопу батону " + str(count + 1) + " раз", "2" + str(count) + ".10.2024", true)
		count = count + 1
	load_data()
