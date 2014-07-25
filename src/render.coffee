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
		day = days[save.clock.day]
		minute = ('00' + Math.floor(save.clock.minute)).substr(-2, 2)
		clockText = "week #{save.clock.week} #{day} #{save.clock.hour}:#{minute}"
		$('#clock').text(clockText)
	
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
		$('#places').empty().append(for name in save.places
			btn = $('<button>').text(name).click(-> travel($(this).text()))
			if save.place == name
				btn.prop('disabled', true)
			btn
		)
		
		place = places[save.place]
		$('#place').text(save.place)
		$('#place-description').text(place.description)
		$('#actions').empty().append(for name, action of place.actions
			if action.visible and !action.visible()
				continue
			btn = $('<button>').text(name)
			btn.click(-> doAction($(this).text()))
			btn
		)
	
	renderEverything: ->
		@renderClock()
		@renderStats()
		@renderInventory()
		@renderMap()
