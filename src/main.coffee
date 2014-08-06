save = {}

saveSave = ->
	json = JSON.stringify(save)
	compressed = LZString.compressToUTF16(json)
	localStorage.setItem('save', compressed)

# Attempts to load save from local storage
# Returns whether loading is successful
loadSave = ->
	compressed = localStorage.getItem('save')
	if compressed
		json = LZString.decompressFromUTF16(compressed)
		save = JSON.parse(json)
		migrate()
		true
	else
		false

# Attempts to fix old saves to work with the newer version
migrate = ->
	switch save.version
		when undefined, 1
			# Too old to migrate
			say "sorry, your save file is too old to recover. :( i probably won't do this again in the future. hopefully the new version will be an enjoyable experience."
			start()

start = ->
	save =
		version: 2
		clock: 6*60
		stats:
			health: 100
			energy: 100
			happiness: 100
			fullness: 100
		skills:
			intellegence: 0
		inventory:
			dollar: 15
		place: 'alley'
		jobs: []
	say "after dropping out of high school and playing video games for the last 2 years, your parents finally kick you out of their basement, leaving you on the streets with no job and just a few bucks. don't spend it all in one place."


$ ->
	gui.init()
	if !loadSave()
		start()
	gui.render()
