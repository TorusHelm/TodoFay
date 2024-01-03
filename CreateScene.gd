extends Control

func save_todo():
	if FileAccess.file_exists(Global.FILE_PATH):
		return
	
	var save = FileAccess.open(Global.FILE_PATH, FileAccess.WRITE)
