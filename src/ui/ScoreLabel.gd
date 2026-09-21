extends Label
class_name ScoreLabel

func _ready() -> void:
	text = "Your score is: "+str(GameData.get_score())
