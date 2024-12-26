extends Node

## Emmitted when an enemy hits the player
signal enemy_hit_player(enemy_name, hp_damage)

## Emmitted when the player's hp changed
signal player_hp_changed(new_hp)

## Emmitted when the player hits the enemy
signal player_hit_enemy_normalshot(damage, enemy_id)

## Emmitted when the player's HP reaches zero.
signal player_died()

## Emmitted when the a body touches spikes
signal player_enter_spikes()

## Emmitted when gravity direction changes
signal gravity_changed(downwards: bool)

## Emmitted when player enters an area on the stage
signal player_enters_room(room_number: int, room_position: Vector2, room_rect: Rect2)

## Emmitted when player is ready to play in level
signal player_teleported_into_level()

## Emmitted when a player touches a ladder
signal player_enters_ladder(ladder_position_global:Vector2)

## Emmitted when a player stops touching a ladder
signal player_leaves_ladder()

## Emmitted when the player initiates lateral motion
signal player_started_moving_lateral()

## Emmitted when the player stops lateral motion
signal player_stopped_moving_lateral()
