@tool
class_name StateMachineManager
extends Node

## Classe responsável por gerenciar state_machine

signal state_changed ## Emitido quando o estado atual muda de valor

@export var initial_state: StateMachine

var machine_child_type: Script = preload("res://state_machine/state_machine.gd") # Representa o tipo de classe que o nó deve ter como filho
var states: Dictionary # Dicionário com a referência de todos os estados disponíveis
var current_state: StateMachine: # As funções enter e exit são chamadas quando current_state muda de valor
	set(new_value):
		if current_state != new_value:
			current_state.exit()
			new_value.enter()
			current_state = new_value
			state_changed.emit()
		else:
			print_debug("current_state tentou mudar para o mesmo estado.")

func _ready():
	_check_children_type()
	_create_states_and_connect_signal()
	_initialize_custom_variables()
	
	if initial_state:
		current_state = initial_state

func _check_children_type() -> void:
	for child in get_children():
		if child.get_script() != machine_child_type:
			assert(false, "O nó %s não é do tipo esperado!" % [child.name])

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)
		
## Função usada para transição manual dos estados
func manual_transition(new_state_name: String) -> void:
	var new_state: StateMachine = states.get(new_state_name.to_lower())
	if not new_state:
		print_debug("{0} estado passado no parâmetro é inválido.".format(new_state))
		return

	current_state = new_state

## Chamado pelos estados filhos desse nó gerencia a transição de um estado para outro
func _state_transitioned(state: StateMachine, new_state_name: String) -> void:
	if state != current_state:
		print_debug("{0} tentou alternar de estado, sendo que este não é o estado atual.".format(state))
		return
		
	var new_state: StateMachine = states.get(new_state_name.to_lower())
	if not new_state:
		print_debug("{0} tentou alternar para o estado {1}, que é inexistente.".format([state, new_state_name]))
		return
	
	current_state = new_state

## Adiciona os estados ao dicionário states e conecta o sinal de transição ao state_machine_manager
func _create_states_and_connect_signal() -> void:
	for child: StateMachine in get_children():
		child.transitioned.connect(_state_transitioned)
		states[child.name.to_lower()] = child

func _initialize_custom_variables() -> void:
	pass
