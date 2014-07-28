days = [
	'monday'
	'tuesday'
	'wednesday'
	'thursday'
	'friday'
	'saturday'
	'sunday'
]

gui =
	render: ->
		@renderClock()
		@renderStats()
		@renderInventory()
		@renderMap()
	
	say: (msg) ->
		$('#story').prepend($('<p>').text(msg))
		$('#story p').slice(8).remove()
	
	renderClock: ->
		$('#clock').text(clockToString())
	
	renderStats: ->
		$('#stats').empty()
		$('#stats').append(for name, quantity of save.stats
			td1 = $('<td>').text(name)
			td2 = $('<td>').addClass('right').text(quantity)
			$('<tr>').append(td1, td2)
		)
	
	renderInventory: ->
		$('#inventory').empty()
		$('#inventory').append(for item, quantity of save.inventory
			if quantity != 0
				td1 = $('<td>')
				if items[item]
					btn = $('<button>').addClass('link').text(item)
					gui.attachAction(btn, items[item])
					td1.append(btn)
				else
					td1.text(item)
				td2 = $('<td>').addClass('right').text(quantity || '')
				$('<tr>').append(td1, td2)
		)
	
	renderMap: ->
		$('#places').empty()
		$('#places').append(for name, place of places
			btn = $('<button>').text(name)
			if save.place == name
				btn.prop('disabled', true)
			gui.attachAction(btn, place.travel)
			btn
		)
		
		place = places[save.place]
		$('#place').text(save.place)
		$('#place-description').text(place.description)
		
		$('#actions').empty().append(for name, action of place.actions
			if !action.visible or action.visible()
				btn = $('<button>').text(name)
				gui.attachAction(btn, action)
				btn
		)
		
		if place.store
			$('#store').css('display', 'block')
		else
			$('#store').css('display', 'none')
		$('#store-items').empty()
		$('#store-items').append(for itemName, price of place.store
			args = {dollar: -price}
			args[itemName] = 1
			buyAction =
				transaction: -> new Transaction(args)
			btn = $('<button>').text(itemName)
			gui.attachAction(btn, buyAction)
			btn
		)
	
	openTooltip: (transaction) ->
		$('#tooltip-transaction').empty()
		$('#tooltip-transaction').append(for name, delta of transaction.flatten()
			td1 = $('<td>').text(name)
			td2 = $('<td>').addClass('right')
			if delta > 0
				td2.append($('<span>').addClass('good').text('+' + delta))
			if delta < 0
				td2.append($('<span>').addClass('bad').text(delta))
			$('<tr>').append(td1, td2)
		)
		$('#tooltip').css('display', 'block')
	
	closeTooltip: ->
		$('#tooltip').css('display', 'none')
	
	attachAction: (el, action) ->
		# TODO
		# Define the functions here, instead of in Util
		# (or find some way to subclass an Action class)
		el.click(-> doAction(action); clearTransaction())
		el.mouseenter(-> setTransaction(action))
		el.mouseleave(-> clearTransaction())
