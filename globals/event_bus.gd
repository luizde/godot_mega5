extends Node

## Emmitted when an enemy hits the player
signal enemy_hit_player(enemy_name, hp_damage)

## Emmitted when the player's hp changed
signal player_hp_changed(new_hp)

## Emmitted when the player hits the enemy
signal player_hit_enemy_normalshot(damage)

## Emmitted when the a body touches spikes
signal player_enter_spikes()

## Emmitted when gravity direction changes
signal gravity_changed()

## Emmitted when player enters an area on the stage
signal player_enters_room(room_number: int, room_position: Vector2)
