extends ViewportContainer
class_name LevelLayer


onready var camera_pivot := $Viewport/camera_pivot as Node2D
onready var camera_remote_transform := $camera_pivot_remote as RemoteTransform2D
onready var camera := $Viewport/camera_pivot/camera as Camera2D
onready var viewport := $Viewport as Viewport
