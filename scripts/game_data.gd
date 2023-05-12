extends Node


# Encounter Data

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
	

enum COLUMN_TYPE {SIEGE,RANGED,INFANTRY}
const SIEGE = "siege"
const RANGED = "ranged"
const INFRANTRY = "infantry"

enum MOVE_DIRECTION {LEFT, RIGHT}
const LEFT = 0
const RIGHT = 1


## Cards
enum CARD_TYPE {SKILL,UNIT}
const SKILL = 0
const UNIT = 1

## State 

const START_STATE_INTRO_TIMEOUT : float = 3.0
