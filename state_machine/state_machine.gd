class_name StateMachine
extends Node

@warning_ignore("unused_signal")
signal transitioned(state, new_state)

## Deve ser chamado somente dentro de _process().
func update(_delta: float) -> void:
	pass

## Deve ser chamado somente dentro de _physics_process().
func physics_update(_delta: float) -> void:
	pass

## Deve ser chamado somente quando o estado passa a ser o estado atual do state_machine_manager.
func enter() -> void:
	pass

## Deve ser chamado somente quando o estado era o estado atual, porem mudou para outro estado.
func exit() -> void:
	pass
