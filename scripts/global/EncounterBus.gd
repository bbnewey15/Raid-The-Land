extends Node

# warning-ignore:unused_signal
signal encounter_state_changed(state_name : String)

# warning-ignore:unused_signal
signal draft_state_started
# warning-ignore:unused_signal
signal draft_state_ended

# warning-ignore:unused_signal
signal slot_data_changed(update_action_order: bool)
# warning-ignore:unused_signal

# warning-ignore:unused_signal
signal column_clicked(column: UnitColumn, index: int, button:int)
# warning-ignore:unused_signal
signal place_unit

# warning-ignore:unused_signal
signal action_request_ui(slot: Slot)
# warning-ignore:unused_signal
signal action_activated( slot_data: SlotData)

# request_user_target_unit Uses GameData.ui_active_slot_data
# warning-ignore:unused_signal
signal request_user_target_unit(action_data: ActionData, potential_targets: Array[SlotData])
# warning-ignore:unused_signal
signal end_request_user_target_unit

# warning-ignore:unused_signal
signal fight_state_started
# warning-ignore:unused_signal
signal fight_state_stopped

# warning-ignore:unused_signal
signal unit_turn_ended

# warning-ignore:unused_signal
#signal slot_attacked(slot_data: SlotData, unit_attacking: SlotData)
# warning-ignore:unused_signal
#signal unit_attack_finished(unit_attacking: SlotData)
# warning-ignore:unused_signal
signal post_fight_state_started
# warning-ignore:unused_signal
signal post_fight_state_ended

# warning-ignore:unused_signal
signal target_hovered(slot_data: SlotData)
# warning-ignore:unused_signal
signal target_hover_exited(slot_data:SlotData)
# warning-ignore:unused_signal
signal target_selected(slot_data: SlotData, button: int)

# warning-ignore:unused_signal
signal slot_hovered(slot_data: SlotData)
# warning-ignore:unused_signal
signal slot_hover_exited(slot_data:SlotData)
# warning-ignore:unused_signal
signal unit_selected(slot_data: SlotData, button: int)

# warning-ignore:unused_signal
signal debug_ui(debug: bool)


# UI 
# warning-ignore:unused_signal
signal ui_active_slot_data_changed 
