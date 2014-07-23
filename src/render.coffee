days = [
	'monday'
	'tuesday'
	'wednesday'
	'thursday'
	'friday'
	'saturday'
	'sunday'
]

renderer =
	renderClock: ->
		fixTime()
		day = days[save.clock.day]
		minute = ('00' + Math.floor(save.clock.minute)).substr(-2, 2)
		clockHtml = "week #{save.clock.week} #{day} #{save.clock.hour}:#{minute}"
		$('#clock').text(clockHtml)
	
	renderStats: ->
		$('#stats').empty().append(for stat, value of save.stats
			$('<tr>')
				.append($('<td>').text(stat))
				.append($('<td>').addClass('right').text(value))
		)
	
	renderInventory: ->
		$('#inventory').empty().append(for item, quantity of save.inventory
			$('<tr>')
				.append($('<td>').text(item))
				.append($('<td>').addClass('right').text(quantity || ''))
		)
	
	renderMap: ->
		$('#places').empty().append(for place in save.places
			placeButton = $('<button>').text(place).click(->
				travel($(this).text())
			)
			if save.place == place
				placeButton.prop('disabled', true)
			placeButton
		)
		$('#place').text(save.place)
		$('#place-description').text(places[save.place].description)
	
	renderEverything: ->
		@renderClock()
		@renderStats()
		@renderInventory()
		@renderMap()
