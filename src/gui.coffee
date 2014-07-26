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
	template: doT.template($('#template').html())
	story: []
	transaction: null
	
	render: ->
		$('#main').html(@template())
	
	renderStats: ->
		$('#stats').empty().append(for name, value of save.stats
			tr = $('<tr>')
			tr.append($('<td>').text(name))
			td = $('<td>').addClass('right').text(value)
			if @transaction
				quantity = @transaction.stats[name]
				if quantity?
					span = $('<span>').text(quantity)
					if quantity < 0
						span.addClass('bad')
					else
						span.addClass('good')
					td.append(span)
			tr.append(td)
			tr
		)
	
	renderInventory: ->
		$('#inventory').empty().append(for item, quantity of save.inventory
			$('<tr>')
				.append($('<td>').text(item))
				.append($('<td>').addClass('right').text(quantity || ''))
		)
	
	renderMap: ->
		$('#actions').empty().append(for name, action of place.actions
			if action.visible and !action.visible()
				continue
			btn = $('<button>').text(name)
			btn.click(-> doAction($(this).text()))
			btn
		)
