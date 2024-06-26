extends Node

# warning-ignore:unused_signal
signal encounter_state_changed(state_name : String)

# warning-ignore:unused_signal
signal draft_state_started
# warning-ignore:unused_signal
signal draft_state_ended

# warning-ignore:unused_signal
signal slot_data_changed()
# warning-ignore:unused_signal

# warning-ignore:unused_signal
signal column_clicked(column: UnitColumn, index: int, button:int)
# warning-ignore:unused_signal
signal place_unit

# warning-ignore:unused_signal
signal card_slot_clicked(card_slot: CardSlot)
# warning-ignore:unused_signal
signal card_played(card_slot: CardSlot)
# warning-ignore:unused_signal
signal card_post_play(card_slot: CardSlot, column_type: GameData.COLUMN_TYPE, index: int, button: int)

# warning-ignore:unused_signal
signal level_up_request_ui(slot: Slot)
# warning-ignore:unused_signal
signal level_up_finished

# warning-ignore:unused_signal
signal action_request_ui(slot: Slot)
# warning-ignore:unused_signal
signal ai_action_request(slot_data: SlotData)
# warning-ignore:unused_signal
signal ai_intent_request(round: int)
# warning-ignore:unused_signal
signal action_activated( slot_data: SlotData, card_slot: CardSlot)
# warning-ignore:unused_signal
signal action_completed(slot_data: SlotData)

# warning-ignore:unused_signal
signal action_slider_requested(action_data: ActionData, slot_data: SlotData, target_slot_data: SlotData)
# warning-ignore:unused_signal
signal action_slider_completed(action_slider_type: GameData.ACTION_SLIDER_HIT)


# request_user_target_unit Uses GameData.ui_active_slot_data
# warning-ignore:unused_signal
signal request_user_target_unit(card_slot: CardSlot, potential_targets: Array[SlotData])
# warning-ignore:unused_signal
signal end_request_user_target_unit

# warning-ignore:unused_signal
signal slot_move_columns(slot: Slot, column_name: GameData.COLUMN_STRING)

# warning-ignore:unused_signal
signal fight_state_started
# warning-ignore:unused_signal
signal fight_state_stopped

# warning-ignore:unused_signal
signal unit_turn_started(slot_data : SlotData)
# warning-ignore:unused_signal
signal unit_turn_ended(slot_data : SlotData)

# warning-ignore:unused_signal
signal new_round_started(round: int)

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
# warning-ignore:unused_signal
signal ui_active_card_slot_changed

# warning-ignore:unused_signal
signal request_recalculate_unit_order
# warning-ignore:unused_signal
signal finished_recalculate_unit_order

