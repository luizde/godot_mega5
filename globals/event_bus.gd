extends Node

## Emmitted when an enemy hits the player
signal enemy_hit_player(enemy_name, hp_damage)

signal player_hp_changed(new_hp)

signal player_hit_enemy_normalshot(damage)
