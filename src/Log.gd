extends Node

signal logged(text: String)

var log_lines: Array[String] = []

func log(text: String) -> void:
	log_lines.append(text+"\n")
	logged.emit(text+"\n")
