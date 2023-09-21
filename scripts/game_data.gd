extends Node


# State
var ui_active_slot_data : SlotData
var full_slot_array: Array[SlotData] = []

# setter
func set_ui_active_slot_data(slot_data: SlotData):
	ui_active_slot_data = slot_data
	EncounterBus.ui_active_slot_data_changed.emit()

# Encounter Data
const UNIT_SIZE = Vector2(110,110)
const COLUMN_SIZE = Vector2(150,614)
## Player
const siegeColumnLocation: Vector2 = Vector2(99, 20)
const siegeColumnRotation: float = 6.8
const infantryColumnLocation: Vector2 = Vector2(273, 20)
const infantryColumnRotation: float = 3.6
const rangedColumnLocation: Vector2 = Vector2(442, 20)
const rangedColumnRotation: float = .8

## Enemey
const siegeEnemyColumnLocation: Vector2 = Vector2(945, 20)
const siegeEnemyColumnRotation: float = -6.8
const infantryEnemyColumnLocation: Vector2 = Vector2(772, 20)
const infantryEnemyColumnRotation: float = -3.6
const rangedEnemyColumnLocation: Vector2 = Vector2(602, 20)
const rangedEnemyColumnRotation: float = -.8

enum COLUMN_STRING {PLAYER_SIEGE_COL, PLAYER_RANGED_COL, PLAYER_INFANTRY_COL,ENEMY_INFANTRY_COL, ENEMY_RANGED_COL,ENEMY_SIEGE_COL  }
const PLAYER_SIEGE_COL = "playerSiegeCol"
const PLAYER_RANGED_COL = "playerRangedCol"
const PLAYER_INFANTRY_COL = "playerInfantryCol"
const ENEMY_SIEGE_COL = "enemySiegeCol" 
const ENEMY_RANGED_COL ="enemyRangedCol"
const ENEMY_INFANTRY_COL ="enemyInfantryCol"

static func getColumnStringByIndex(index : int) -> String:
	return GameData[GameData.COLUMN_STRING.keys()[index]]
	
func getColumnStringByColumnType(column_type: COLUMN_TYPE, isEnemy: bool =false)-> String:
	var return_value = null
	var test = COLUMN_TYPE.keys()[column_type]
	
	if isEnemy:
		match GameData[COLUMN_TYPE.keys()[column_type]]:
			SIEGE:
				return_value = ENEMY_SIEGE_COL
			RANGED:
				return_value = ENEMY_RANGED_COL
			INFANTRY:
				return_value = ENEMY_INFANTRY_COL
	else:
		match GameData[COLUMN_TYPE.keys()[column_type]]:
			SIEGE:
				return_value = PLAYER_SIEGE_COL
			RANGED:
				return_value = PLAYER_RANGED_COL
			INFANTRY:
				return_value = PLAYER_INFANTRY_COL
				
	assert(return_value)
	return return_value

enum COLUMN_TYPE {SIEGE,RANGED,INFANTRY}
const SIEGE = "siege"
const RANGED = "ranged"
const INFANTRY = "infantry"

enum MOVE_DIRECTION {LEFT, RIGHT}
const LEFT = 0
const RIGHT = 1

enum UNIT_ACTIONS {ATTACK, DEFEND, SUPPORT}
const ATTACK = 0
const DEFEND = 1
const SUPPORT = 2

## Cards
enum CARD_TYPE {SKILL,UNIT}
const SKILL = 0
const UNIT = 1

## State 

const START_STATE_INTRO_TIMEOUT : float = 3.0


func actionOrderComparison(a : SlotData, b : SlotData):
	if !a.can_action():
		return true
	if !b.can_action():
		return false
		
	if typeof(a.action_order) != typeof(b.action_order):
		return typeof(a.action_order) < typeof(b.action_order)
	else:
		return a.action_order < b.action_order
