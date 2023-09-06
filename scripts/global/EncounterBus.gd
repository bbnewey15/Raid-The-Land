extends Node

# warning-ignore:unused_signal
signal encounter_state_changed(state_name : String)
# warning-ignore:unused_signal
signal slot_data_changed
# warning-ignore:unused_signal
signal place_state_started
# warning-ignore:unused_signal
signal place_state_ended
# warning-ignore:unused_signal
signal player_place_ended_turn
# warning-ignore:unused_signal
signal card_slot_clicked(card_slot: CardSlot, column_type: GameData.COLUMN_TYPE, index: int, button: int)
# warning-ignore:unused_signal
signal card_played(card_slot: CardSlot, column_type: GameData.COLUMN_TYPE, index: int, button: int)
# warning-ignore:unused_signal
signal card_post_play(card_slot: CardSlot, column_type: GameData.COLUMN_TYPE, index: int, button: int)
# warning-ignore:unused_signal
signal column_clicked(column: UnitColumn, index: int, button:int)
# warning-ignore:unused_signal
signal place_unit

# warning-ignore:unused_signal
signal order_state_started
# warning-ignore:unused_signal
signal order_state_ended

# warning-ignore:unused_signal
signal fight_state_started(units_data : UnitColumnData)
# warning-ignore:unused_signal
signal fight_state_stopped
# warning-ignore:unused_signal
signal fight_action_started
# warning-ignore:unused_signal
signal fight_action_stopped
# warning-ignore:unused_signal
signal column_attacked(unit_column: UnitColumn, unit_attacking: SlotData)
# warning-ignore:unused_signal
signal unit_attack_finished(unit_attacking: SlotData)
# warning-ignore:unused_signal
signal post_fight_state_started(units_data : UnitColumnData)
# warning-ignore:unused_signal
signal post_fight_state_stopped
# warning-ignore:unused_signal

# warning-ignore:unused_signal
signal unit_selected(unit_col_data: UnitColumnData, index: int, colIndex: int, button: int)

# warning-ignore:unused_signal
signal debug_ui(debug: bool)
