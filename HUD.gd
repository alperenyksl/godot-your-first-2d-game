extends Control
signal start_game

func update_score(score):
	$ScoreLabel.text = str(score)

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	await $MessageTimer.timeout 
	#$Message.text = "Dodge the Creeps!"
	#$Message.show()
	
	await get_tree().create_timer(1.0).timeout 

	$StartButton.show() 

func _on_message_timer_timeout():
	$Message.hide()

func _on_start_button_pressed():
	$StartButton.hide()
	start_game.emit()

func show_start_button_only():
	# 1 saniye bekleme
	await get_tree().create_timer(1.0).timeout
	# Butonu göster
	$StartButton.show()
func show_initial_message():
	# Bu fonksiyon sadece oyun açıldığında çalışır
	$ScoreLabel.text = "0" # Skorun 0 görünmesini garantile
	$Message.text = "Dodge the Creeps!" # Başlangıç mesajını ayarla
	$Message.show()
	# 1 saniye bekledikten sonra butonu gösterme akışı
	await get_tree().create_timer(1.0).timeout 
	$StartButton.show()
