extends Node

@export var mob_scene: PackedScene
var score = 0

# OYUN BAŞLAMADAN ÖNCEKİ İLK ADIM
func _ready():
	randomize()
	
	# HUD'a başlangıç ekranını göstermesini söyler (Butonu gösterir, 'Get Ready!' mesajını ayarlar)
	_set_up_start_screen() 
	
	pass
	
# ----------------- YENİ EKLENEN FONKSİYON: BAŞLANGIÇ EKRANINI HAZIRLAMA -----------------
func _set_up_start_screen():
	# Bu fonksiyon, StartTimer dolana kadar bekler ve butonu gösterir.
	$HUD.update_score(0)
	
	# HOCANIN İSTEĞİ: OYUN BAŞLAMADAN ÖNCE "Get Ready!" çıkmalı
	$HUD.show_message("Get Ready!")
	
	# Mesajın bitmesini bekle ve butonu göster
	await $HUD.show_start_button_only()


# ----------------- OYUN DURUMU KONTROL FONKSİYONLARI -----------------

func game_over():
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func new_game():
	get_tree().call_group("mobs", "queue_free")
	score = 0
	$HUD.update_score(score)
	
	# HOCANIN İSTEĞİ: OYUN BAŞLADIĞINDA "Dodge the Creeps!" göster
	$HUD.show_message("Dodge the Creeps!")
	
	# KOD GÜVENLİĞİ: Player'dan hit sinyalini koda bağla
	if not $Player.is_connected("hit", Callable(self, "game_over")):
		$Player.connect("hit", Callable(self, "game_over"))
		
	$Player.start($StartPosition.position)
	$StartTimer.start()
	$Music.play()

# ----------------- TİMER SİNYAL FONKSİYONLARI -----------------

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_mob_timer_timeout():
	var mob = mob_scene.instantiate()
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()
	mob.position = mob_spawn_location.position
	var direction = mob_spawn_location.rotation + PI / 2
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	add_child(mob)
