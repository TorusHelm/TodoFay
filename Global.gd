extends Node

const SAVE_DIR = "user://saves/"
const SAVE_FILE_NAME = "todo.json"
const SECURITY_KEY = "ASD978"
const SAVE_PATH = SAVE_DIR + SAVE_FILE_NAME
const ICON_EDIT = preload("res://assets/images/edit.svg")
const ICON_REMOVE = preload("res://assets/images/remove.svg")

var current_todo
