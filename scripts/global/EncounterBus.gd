extends Node

# Emitted whenever a card is rotated
# warning-ignore:unused_signal
signal card_rotated(card,details)
# Emitted whenever a card flips up/down
# warning-ignore:unused_signal
signal card_flipped(card,details)
# Emitted whenever a card is viewed while face-down
# warning-ignore:unused_signal
signal card_viewed(card,details)
# Emited whenever a card is moved to the board
# warning-ignore:unused_signal
signal card_moved_to_board(card,details)
# Emited whenever a card is moved to a pile
# warning-ignore:unused_signal
signal card_moved_to_pile(card,details)
# Emited whenever a card is moved to a hand
# warning-ignore:unused_signal
signal card_moved_to_hand(card,details)
# Emited whenever a card's tokens are modified
# warning-ignore:unused_signal
signal card_token_modified(card,details)
# Emited whenever a card attaches to another
# warning-ignore:unused_signal
signal card_attached(card,details)
# Emited whenever a card unattaches from another
# warning-ignore:unused_signal
signal card_unattached(card,details)
# Emited whenever a card properties are modified
# warning-ignore:unused_signal
signal card_properties_modified(card,details)
# Emited whenever a new card has finished being added to the gane through the scripting engine
# warning-ignore:unused_signal
signal card_spawned(card,details)
# Emited whenever a card is targeted by another card.
# This signal is not fired by this card directly like all the others, 
# but instead by  the card doing the targeting.
# warning-ignore:unused_signal
signal card_targeted(card,details)
# warning-ignore:unused_signal
signal counter_modified(card,details)
# warning-ignore:unused_signal
signal shuffle_completed(card_container,details)

signal card_played(card,details)
# warning-ignore:unused_signal
signal card_removed(card,details)
# warning-ignore:unused_signal
signal selection_window_opened(selection_window, details)
# warning-ignore:unused_signal
signal card_selected(selection_window, details)
# warning-ignore:unused_signal
signal battle_begun
# warning-ignore:unused_signal
signal player_turn_started(turn)
# warning-ignore:unused_signal
signal player_turn_ended(turn)
# warning-ignore:unused_signal
signal enemy_turn_started(turn)
# warning-ignore:unused_signal
signal enemy_turn_ended(turn)
# warning-ignore:unused_signal
signal cards_fused(card)
# warning-ignore:unused_signal
signal card_drafted(card)

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
signal unit_selected(unit_col_data: UnitColumnData, index: int, colIndex: int, button: int)
