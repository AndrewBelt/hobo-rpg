
gui =
	init: ->
		$('#version').text("v0.2")
		FastClick.attach(document.body)
		$('body').mousemove (e) ->
			$('#tooltip').css(left: e.pageX, top: e.pageY + 20)
		$('#reset').click ->
			if window.confirm("you are about to reset your save file.")
				start()
				gui.render()

	render: ->
		@renderClock()
		@renderInfo()
		@renderMap()

		darkness = clip(1 + 2 * Math.cos(2*Math.PI * (save.clock / (60*24) % 1)), 0, 1)
		bg = Math.floor(255 - 100*darkness)
		$('body').css('background-color', "rgb(#{bg}, #{bg}, #{bg})")

	say: (msg) ->
		$('#story').prepend($('<p>').text(msg))
		$('#story p').slice(8).remove()

	renderClock: ->
		$('#clock').text(clock.toString())

	renderInfo: ->
		$('#stats').empty().append(for name, quantity of save.stats
			td1 = $('<td>').text(name)
			td2 = $('<td>').addClass('right').text(quantity)
			$('<tr>').append(td1, td2)
		)

		$('#skills').empty().append(for name, quantity of save.skills
			td1 = $('<td>').text(name)
			td2 = $('<td>').addClass('right').text(quantity)
			$('<tr>').append(td1, td2)
		)

		$('#inventory').empty().append(for item, quantity of save.inventory
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
		$('#places').empty().append(for name, place of places
			continue if place.visible and !place.visible()
			btn = $('<button>').text(name)
			# Disable button if already there
			if save.place == name
				btn.prop('disabled', true)

			do (name) ->
				travelAction =
					transaction: -> new Transaction(minute: 15)
					run: ->
						save.place = name
						gui.openPanel("walking to #{name}...")
				gui.attachAction(btn, travelAction)

			btn
		)

		place = places[save.place]
		$('#place').text(save.place)
		$('#place-description').text(place.description())

		$('#actions').empty().append(for name, action of place.actions
			continue if action.visible and !action.visible()
			btn = $('<button>').text(name)
			gui.attachAction(btn, action)
			btn
		)

		store = place.store
		$('#buy').empty()
		if store and (!store.visible or store.visible())
			$('#store').css('display', 'block')
			$('#buy').append(for itemName, price of store.buy
				do (itemName, price) ->
					args = {dollar: -price}
					args[itemName] = 1
					buyAction =
						transaction: -> new Transaction(args)
					btn = $('<button>').text(itemName)
					gui.attachAction(btn, buyAction)
					btn
			)
		else
			$('#store').css(display: 'none')

	openTooltip: (transaction) ->
		$('#tooltip-transaction').empty().append(for name, delta of transaction.flatten()
			td1 = $('<td>').text(name)
			td2 = $('<td>').addClass('right')
			if delta > 0
				td2.append($('<span>').addClass('good').text('+' + delta))
			if delta < 0
				td2.append($('<span>').addClass('bad').text(delta))
			$('<tr>').append(td1, td2)
		)
		$('#tooltip').css(display: 'block')

	closeTooltip: ->
		$('#tooltip').css(display: 'none')

	attachAction: (el, action) ->
		el.click ->
			if action.transaction
				transaction = action.transaction()
				error = transaction.error()
				if error
					say "not enough #{error}"
					return
				else
					transaction.commit()
			if action.run
				action.run()
			checkStats()
			gui.render()
			gui.closeTooltip()
			saveSave()

		el.mouseenter ->
			if action.transaction
				transaction = action.transaction()
				gui.openTooltip(transaction)

		el.mouseleave ->
			gui.closeTooltip()

	openPanel: (text, callback) ->
		$('#panel-text').text(text)
		$('#mask').css(display: 'block')
		window.setTimeout((->
			$('#mask').css(display: 'none')
			callback() if callback
		), 600)
