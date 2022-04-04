extends Node2D

func _ready():
	$rope.pointA = $player/pointA
	$rope.pointB = $arrow/pointB
	$arrow._on_terrain_area_body_entered($terrain)
