extends Resource
class_name ActionData

var current_action : Action

@export var name = "ACTION_NAME"
@export var description = "DESCRIPTION"
@export var icon_path = GameData.SUPPORT_ICON

@export var level_required : int = 1
@export var upgrade_price : int = 1

@export var ap_cost : int = 2
@export var will_end_turn : bool = false
@export var action_range : Array[int] = []

@export var action_type : GameData.UNIT_ACTIONS = GameData.UNIT_ACTIONS.ATTACK
@export var target_type : GameData.ACTION_TARGET_TYPE = GameData.ACTION_TARGET_TYPE.TARGET_SELF
@export var action_amount_ratio : float = .55
@export var requires_target = false
@export var number_of_targets : int = 0
@export var number_of_actions : int = 1

@export var apply_condition: bool = true
@export var conditions: Array[GameData.CONDITIONS] = [GameData.CONDITIONS.STRENGTHEN]
@export var condition_stacks : int = 3

