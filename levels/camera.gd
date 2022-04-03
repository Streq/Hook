extends Camera2D

func _ready():
	zoom = Global.zoom
	Global.connect("zoom_changed", self, "update_zoom")
	
func update_zoom():
	zoom = Global.zoom
