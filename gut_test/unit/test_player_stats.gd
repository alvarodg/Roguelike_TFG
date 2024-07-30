extends GutTest

var stats: PlayerStats

func before_each():
	stats = PlayerStats.new(100)
	
func test_coin_count_changed():
	watch_signals(stats)
	stats.coin_count = 4
	assert_signal_emitted_with_parameters(stats, 'coin_count_changed', [5, 4])
