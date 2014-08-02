save = {}

saveSave = ->
	json = JSON.stringify(save)
	compressed = LZString.compressToUTF16(json)
	localStorage.setItem('save', compressed)

loadSave = ->
	compressed = localStorage.getItem('save')
	if compressed
		json = LZString.decompressFromUTF16(compressed)
		save = JSON.parse(json)
		true
	else
		false

start = ->
	save =
		clock: 6*60
		stats:
			health: 100
			energy: 100
			happiness: 100
			intellegence: 0
		inventory:
			dollar: 15
		place: 'alley'
		jobs: []
	say "after dropping out of high school and playing video games for the last 2 years, your parents finally kick you out of their basement, leaving you on the streets with no job and just a few bucks. don't spend it all in one place."


$ ->
	if !loadSave()
		start()
	window.setInterval(saveSave, 5000)
	FastClick.attach(document.body)
	gui.render()
