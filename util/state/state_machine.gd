extends Node
class_name StateMachine

signal state_changed(state_name, args)

export (NodePath) onready var initial_state = get_node(initial_state) as State
var states := []
var state_map := {}
var current_state_name := ""
var current_state : State = null

func _ready():
	for state in get_children():
		state_map[state.name] = state
		(state as State).connect("finished", self, "_on_state_finished")
	_change_state(initial_state)

func _physics_process(delta):
	current_state.update(delta)
	
func _input(event):
	current_state.input(event)
	
func _on_state_finished(new_state_name:String, args):
	var new_state : State = state_map[new_state_name]
	_change_state(new_state, args)
	pass
	
func _change_state(new_state:State, args = null):
	if !states.empty():
		var old_state : State = states.pop_back()
		old_state.exit()
	
	
	states.push_back(new_state)
	new_state.enter(args)
	
	current_state = new_state
	current_state_name = new_state.name
	
	emit_signal("state_changed", current_state_name, args)

