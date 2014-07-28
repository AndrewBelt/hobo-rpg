save = {}

start = ->
	say("after dropping out of high school and playing video games for the last 2 years, your parents finally kick you out of their basement, leaving you on the streets with no job and just a few bucks. don't spend it all in one place.")
	save =
		clock: 6*60
		stats:
			energy: 100
			health: 100
			intellegence: 0
		inventory:
			dollar: 15
		place: 'alley'
		jobs: []


start()
gui.render()
