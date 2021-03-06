math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6)) )
-- TODO: Add randomMoveName and a move names list to make characters more deep. Each generated characer will have a finisher. Also used on random events.

function love.load()
	RETURN_TO = false
	ACTIVITIES = {}
	ACTIVITIES[1] = {name = "Take drugs", health = 6, money = -40, max_health = -6, popularity = 0}
	ACTIVITIES[2] = {name = "Hit the town", health = -6, money = -40, max_health = -1, popularity = 5}
	ACTIVITIES[3] = {name = "Work night shift", health = -6, money = 20, max_health = 0, popularity = 0}
	ACTIVITIES[4] = {name = "Stay in", health = 1, money = -5, max_health = 0, popularity = 0}
	ACTIVITIES[5] = {name = "Retire", health = 0, money = 0, max_health = 0, popularity = 0}

	PRE_ACTIVITIES = {}
	PRE_ACTIVITIES[1] = {name = "Take drugs", health = 6, money = -40, max_health = -6, popularity = 0}
	PRE_ACTIVITIES[2] = {name = "Hit the town", health = -6, money = -40, max_health = -1, popularity = 5}
	PRE_ACTIVITIES[3] = {name = "Hit the gym", health = 6, money = -60, max_health = 0, popularity = 0}
	PRE_ACTIVITIES[4] = {name = "Stay in", health = 1, money = -5, max_health = 0, popularity = 0}
	PRE_ACTIVITIES[5] = {name = "Retire", health = 0, money = 0, max_health = 0, popularity = 0}

	WORK_MODES = {}
	WORK_MODES[1] = {name = "Go All Out", health = 20, popularity = 7}
	WORK_MODES[2] = {name = "Normal", health = 12, popularity = 3}
	WORK_MODES[3] = {name = "Take It Easy", health = 6, popularity = 1}

	BUTTONS = {}

	MATCHES = {}

	EPHEMERAL_MESSAGES = {}

	RANDOM_GYM_EVENTS = {}
	RANDOM_GYM_EVENTS[1] = {title="Street Fight", description="You got blindsided by a 'fan' at the gym, and were beaten pretty badly. Then you noticed your wallet was lighter... ", health = -10, money = "-half", max_health = -2, popularity = -10}
	RANDOM_GYM_EVENTS[2] = {title="Workout Groove", description="You're in a groove with your workout. Your maximum health is slightly increased.", health = 1, money = 0, max_health = 1, popularity = 0}
	RANDOM_GYM_EVENTS[3] = {title="Mild Injury", description="You sprained your ankle in training. Your max health went down slightly.", health = -1, money = 0, max_health = -1, popularity = 0}
	RANDOM_GYM_EVENTS[4] = {title="Stolen Passport", description="Some jerk stole your passport and took a bunch of your money.", health = 0, money = "-half", max_health = 0, popularity = 0}
	RANDOM_GYM_EVENTS[5] = {title="Arm Wrestling Champ", description="You won an arm wrestling competition at the gym.", health = 0, money = 50, max_health = 0, popularity = 5}
	RANDOM_GYM_EVENTS[6] = {title="Good Trainer", description="You've got a new trainer. They're helping you a lot.", health = 0, money = 0, max_health = 2, popularity = 0}
	RANDOM_GYM_EVENTS[7] = {title="New Sponsor", description="You got a new sponsor due to your gym prowess.", health = 0, money = 100, max_health = 0, popularity = 10}
	RANDOM_GYM_EVENTS[7] = {title="Bad Trainer", description="You've got a new trainer. You're not getting along with them.", health = -5, money = 0, max_health = -1, popularity = 0}

	RANDOM_MATCH_EVENTS = {}
	RANDOM_MATCH_EVENTS[1] = {title="Mild Injury", description="You pulled a muscle in the match. It'll be sore for awhile.", health = -10, money = 0, max_health = -2, popularity = 0}
	RANDOM_MATCH_EVENTS[2] = {title="Great Match", description="You really stole the show out there tonight. The crowd loved it.", health = 0, money = 0, max_health = 0, popularity = 5}
	RANDOM_MATCH_EVENTS[3] = {title="Bad Match", description="You stunk up the joint out there. The people did not like what they saw.", health = 0, money = 0, max_health = 0, popularity = -5}
	RANDOM_MATCH_EVENTS[4] = {title="Something Clicked", description="You can't explain it, but you just feel more comfortable in the ring now.", health = 0, money = 0, max_health = 0, popularity = 1}
	RANDOM_MATCH_EVENTS[5] = {title="Serious Injury", description="Your opponnent dropped you hard on your neck. You're hurt pretty bad.", health = -30, money = 0, max_health = -10, popularity = 0}
	RANDOM_MATCH_EVENTS[6] = {title="New Move", description="You got the hang of a new technique, and used it well in the match tonight.", health = 0, money = 0, max_health = 0, popularity = 2}
	RANDOM_MATCH_EVENTS[7] = {title="Word of Mouth", description="The quality of your match impressed a lot of people.", health = 0, money = 0, max_health = 0, popularity = 10}

	CURRENT_RANDOM_EVENT = false
	CURRENT_RANDOM_MATCH_EVENT = false
	CURRENT_TERRITORY = 0
	--love.filesystem.load( "table.save-1.0.lua" )()

	window_width, window_height, window_flags = love.window.getMode( )

	love.graphics.setDefaultFilter("nearest", "nearest", 0)
	mainFont = love.graphics.newFont("prstart.ttf",30)
	secondaryFont = love.graphics.newFont("prstart.ttf",20)
	headlineFont = love.graphics.newFont("prstart.ttf",26)
	statFont = love.graphics.newFont("prstart.ttf",16)
	tinyFont = love.graphics.newFont("prstart.ttf",12)

	matchBell = love.audio.newSource("sounds/matchBell.ogg")
	badChoice = love.audio.newSource("sounds/badChoice.ogg")

	day = 1
	
	love.graphics.setFont(mainFont);
	
	-- Right now this just defines how many sprites there are- this is a real dumb way to do so, but it works great.
	number_of_rassler_icons = 23

	nicknamesFirst = loadFileAsTable("nickFirst.txt")

	nicknamesLast = loadFileAsTable("nickLast.txt")

	namesFirst = loadFileAsTable("namesFirst.txt")

	namesLast = loadFileAsTable("namesLast.txt")

	moveNamesFirst = loadFileAsTable("movesFirst.txt")

	moveNamesLast = loadFileAsTable("movesLast.txt")

	moveNamesMods = loadFileAsTable("movesModifier.txt")

	townNamesFirst = loadFileAsTable("hometownFirst.txt")

	townNamesLastFirst = loadFileAsTable("hometownLastFirst.txt")

	townNamesLastLast = loadFileAsTable("hometownLastLast.txt")
	
	match_history = {}
	
	match = {}

	territories = {}

	championships = {}

	bookers = {}

	for i = 1, 3 do
		territories[#territories+1] =  generateTerritory()
	end

	CURRENTLY_SELECTED_TERRITORY = 1

	player = generateRassler(1)

	CURRENT_SCREEN = "title"

	SCREENSHOT_MODE = false

end

function addEphemeralMessage(text)
	EPHEMERAL_MESSAGES[#EPHEMERAL_MESSAGES+1] = {text = text, created_at=os.time(), length=4}
end

function drawEphemeralMessages()
	love.graphics.setFont(statFont)

	if #EPHEMERAL_MESSAGES > 0 then
		love.graphics.setColor(0,0,0)
		love.graphics.rectangle('fill', 0, 200, 800, 80)
	end
	
	love.graphics.setColor(255,255,255)
	for message = 1, #EPHEMERAL_MESSAGES do
		if (os.time() - EPHEMERAL_MESSAGES[message].created_at) < EPHEMERAL_MESSAGES[message].length then
			love.graphics.printf(EPHEMERAL_MESSAGES[message].text, 40, 210, 720, "left")
		else
			table.remove(EPHEMERAL_MESSAGES,message)
		end
	end
end

function drawButtons()
	for button = 1, #BUTTONS do

		box_x = BUTTONS[button].x
		text_x = BUTTONS[button].x+20
		box_y = BUTTONS[button].y
		text_y = BUTTONS[button].y
		width = BUTTONS[button].width

		love.graphics.setFont(mainFont)
		love.graphics.setColor(0, 0, 255, 255)
		love.graphics.rectangle( "fill", box_x, box_y, width, 46 )
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.print(BUTTONS[button].text, text_x, 11+text_y)
	end
end

function saveScreenShot()

	filename = "rassler_" .. os.time();
	screenshot = love.graphics.newScreenshot( )
	screenshot:encode('png', filename .. '.png');

	dir = love.filesystem.getSaveDirectory( )
	addEphemeralMessage("Saved as " .. dir .. "/" .. filename .. ".png", 4)

end

function loadFileAsTable(fileName)

	assert(love.filesystem.isFile(fileName))

	print("Trying to load " .. fileName)

	local_table = {}

	file = love.filesystem.read(fileName)

	--print("Contents: " .. file)

	if love.filesystem.isFile(fileName) then
	    for line in file:gmatch("[^\r\n]+") do
	        table.insert(local_table,line)
	    end

	    return local_table
	else
		print(fileName .. ": no file")
	end
end

function generateRassler(rank)

	local rassler = {}

	player_starting_max_health = math.random(70,100)
	player_starting_health = math.random(70,player_starting_max_health)
	player_starting_money = math.random(50,100)

	rassler['id'] = "wres-" .. generate_uuid()
	rassler['name'] = generateRasslerName()
	rassler['image'] = math.random(1,number_of_rassler_icons)
	rassler['nickname'] = generateRasslerNickname()
	rassler['favorite_move'] = generateFavoriteMove()
	rassler['health'] = player_starting_health*rank
	rassler['max_health'] = player_starting_max_health*rank
	rassler['popularity'] = 0
	rassler['matches'] = 0
	rassler['age'] = math.random(16,40)
	rassler['money'] = player_starting_money
	rassler['money_spent'] = 0
	rassler['money_earned'] = 0
	rassler['active_effects'] = {}
	rassler['athletics'] = math.random(4,18)
	rassler['strength'] = math.random(4,18)
	rassler['showmanship'] = math.random(4,18)
	rassler['technical'] = math.random(4,18)

	return rassler
end

function generateBooker()
	booker = {}

	booker['name'] = generateRasslerName()
	booker['payoffs'] = math.random(1,10)
	booker['scouting'] = math.random(1,10)
	booker['promotion'] = math.random(1,10)
	booker['personality'] = math.random(1,10)

	return booker
end

function drawDebugScreen()
	love.graphics.setFont(statFont)
	local offset = 10
	for i = 1, #territories do
		love.graphics.printf( territories[i].name .. ' - pop' .. territories[i].popularity .. ' - size' .. territories[i].size .. ' - ' .. territories[i].fans .. 'fans - ' .. territories[i].booker.name .. ' - ' .. territories[i].booker.payoffs .. ' - ' .. territories[i].booker.scouting .. ' - ' .. territories[i].booker.promotion .. ' - ' .. territories[i].booker.personality, 10, offset, 690, "left" )
		offset = offset + 40
	end
end

function drawTerritorySelectScreen()
	love.graphics.setColor(200,200,200)
	love.graphics.rectangle('fill', 0, 50 + ((current_territory_choice-1) * 150), 800, 150)
	love.graphics.setColor(255,255,255)
	love.graphics.setFont(mainFont)
	centerText(30, 'Choose Starting Territory', 15)
	love.graphics.setFont(statFont)
	love.graphics.print("Up/Down: Select territory. Enter: Do It", 90,550)
	love.graphics.print("Space: View Territory info", 90,570)

	local start = 60
	local offset = 10
	for i = 1, #territories do
		love.graphics.setColor(0,0,0)
		love.graphics.setFont(mainFont)
		love.graphics.print(territories[i].name, 40, start + offset)
		offset = offset + 40
		love.graphics.setFont(statFont)
		love.graphics.print('Owner: ' .. territories[i].booker.name, 40, start + offset)
		offset = offset + 40

		love.graphics.print('Popularity:', 40, start + offset)
		love.graphics.print('Payoffs:', 230, start + offset)
		love.graphics.print('Fans:', 400, start + offset)
		love.graphics.print('Size:', 500, start + offset)
		offset = offset + 20

		love.graphics.setColor(255,255,255)
		love.graphics.rectangle('fill', 40, start + offset, 100, 20)
		love.graphics.rectangle('fill', 230, start + offset, 100, 20)
		love.graphics.rectangle('fill', 500, start + offset, 100, 20)
		love.graphics.setColor(0,255,0)
		love.graphics.rectangle('fill', 40, start + offset, territories[i].popularity * 10, 20)
		love.graphics.rectangle('fill', 230, start + offset, territories[i].booker.payoffs * 10, 20)
		love.graphics.rectangle('fill', 500, start + offset, territories[i].size * 25, 20)
		love.graphics.setColor(0,0,0)
		love.graphics.print(territories[i].fans, 400, start + offset)
		offset = offset + 50
	end
end

function drawTerritoryInfoScreen()
	love.graphics.setColor(0,0,0) 

	offset = 37
	for j = 1, #territories[CURRENTLY_SELECTED_TERRITORY]['rasslers'] do
		love.graphics.setFont(statFont)
		love.graphics.print(territories[CURRENTLY_SELECTED_TERRITORY]['rasslers'][j]['nickname'] .. " " .. territories[CURRENTLY_SELECTED_TERRITORY]['rasslers'][j]['name'] .. ": " .. territories[CURRENTLY_SELECTED_TERRITORY]['rasslers'][j]['popularity'] .. " Fans", 20, (offset*j) - 30)

		for i = 1, #championships do
			if championships[i]['current_champion'] == territories[CURRENTLY_SELECTED_TERRITORY]['rasslers'][j]['id'] then

				love.graphics.print("c", 0, (offset*j) - 30)
			end
		end

		love.graphics.setFont(tinyFont)
		love.graphics.print("TECH: " .. territories[CURRENTLY_SELECTED_TERRITORY]['rasslers'][j]['technical'], 20, ((offset*j)-30) + 20)
		love.graphics.print("ATH: " .. territories[CURRENTLY_SELECTED_TERRITORY]['rasslers'][j]['athletics'], 130, ((offset*j)-30) + 20)
		love.graphics.print("STR: " .. territories[CURRENTLY_SELECTED_TERRITORY]['rasslers'][j]['strength'], 240, ((offset*j)-30) + 20)
		love.graphics.print("SHOW: " .. territories[CURRENTLY_SELECTED_TERRITORY]['rasslers'][j]['showmanship'], 360, ((offset*j)-30) + 20)
	end

	love.graphics.print("ESC: Go back", 10,570)
end

function generateTerritory()
	territory = {}

	territory['name'] = generateTerritoryName()

	local booker = generateBooker()
	territory['booker'] = booker
	territory['popularity'] = math.random(1,12)
	territory['size'] = math.random(1,4)
	territory['fans'] = math.random(25, territory['popularity'] * (territory['size'] * 50))
	territory['rasslers'] = {}

	for i = 1, 15 do 
		territory['rasslers'][i] = generateRassler(math.random(1,5))
	end

	for i = 1, 15 do
		popularity_roll = math.random(1,territory['fans'])
		territory['rasslers'][i]['popularity'] = popularity_roll
	end

	chosen_champion = math.random(1,15)

	undisputed = false

	for i = 1, 15 do
		if territory['rasslers'][i]['popularity'] >= territory['rasslers'][chosen_champion]['popularity'] then
			chosen_champion = i
		end
	end

	championships[#championships+1] = {id = "title-" .. generate_uuid() , name = territory['name'], current_champion = territory['rasslers'][chosen_champion]['id'], title_history = {}}

	--print(territory['rasslers'][chosen_champion]['name'] .. " is inaugural " .. territory['name'] .. " champion, winning a tournament in Puerto Rico." )
	return territory
end

function savePlayerStatus()
	--assert( table.save( MATCHES, "save1.lua" ) == nil )
end

function love.update(dt)

end

function love.draw()
	love.graphics.setBackgroundColor(150,150,150)

	if CURRENT_SCREEN == "title" then
		drawTitleScreen()
	end

	if CURRENT_SCREEN == "territorySelect" then
		drawTerritorySelectScreen()
	end

	if CURRENT_SCREEN == "territoryInfo" then
		drawTerritoryInfoScreen()
	end

	if CURRENT_SCREEN == "start" then
		drawStartScreen()
	end
	
	if CURRENT_SCREEN == "card" then
		drawCardScreen()
	end
	
	if CURRENT_SCREEN == "match" then
		drawMatchScreen()
	end
	
	if CURRENT_SCREEN == "result" then
		drawResultScreen()
	end
	
	if CURRENT_SCREEN == "debug" then
		drawDebugScreen()
	end
	
	if CURRENT_SCREEN == "road" then
		drawRoadScreen()
	end

	if CURRENT_SCREEN == "prematch" then
		drawPrematchScreen()
	end

	if CURRENT_SCREEN == "gameOverConfirm" then
		drawGameOverConfirmScreen()
	end
	
	if CURRENT_SCREEN == "gameOver" then
		drawEndScreen()
	end

	if CURRENT_SCREEN == "newday" then
		drawNewDayScreen()
	end

	if CURRENT_SCREEN == "randomEvent" then
		drawRandomEventScreen(CURRENT_RANDOM_EVENT)
	end

	if CURRENT_SCREEN == "randomMatchEvent" then
		drawRandomEventScreen(CURRENT_RANDOM_EVENT)
	end

	drawEphemeralMessages()

	if CURRENT_SCREEN ~= "title" then
		-- Buttons don't exist yet. Soon.
		--drawButtons()
	end
end

function drawRandomEventScreen(event)
	love.graphics.setColor(0,0,0)
	--love.graphics.setColor(0,129,249)
	love.graphics.rectangle("fill", 0, 0, window_width, window_height)
	love.graphics.setColor(255,255,255)
	love.graphics.setFont(mainFont)
	centerText(30,"SOMETHING HAPPENED!!", 40)
	centerText(30,event.title, 150)


	love.graphics.printf( event.description, 20, 200, 760, "left" )
	--love.graphics.print(RANDOM_GYM_EVENTS[1].description, 20, 250)

	love.graphics.setColor(200,200,200)
	love.graphics.rectangle("fill", 30, 430, window_width-60, 80)


	love.graphics.setFont(statFont)
	centerText(20,"EFFECTS", 400)
	love.graphics.setColor(0,0,0)
	love.graphics.print("HEALTH / MAX", 40, 440)
	love.graphics.print(event.health .. " / " .. event.max_health, 40, 480)
	
	love.graphics.print("FANS", 520, 440)
	love.graphics.print(event.popularity, 520, 480)
	
	love.graphics.print("$", 670, 440)
	if event.money == "-half" then
		money_effect = math.floor(player.money * 0.5)
		love.graphics.print("-"..money_effect, 670, 480)
	else
		money_effect = event.money
		love.graphics.print(money_effect, 670, 480)
	end

	love.graphics.setColor(255,255,255)
	love.graphics.setFont(mainFont)
	centerText(30,"Press Start to Continue", window_height-50)
	
end

function drawGameOverConfirmScreen()
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill", 0, 0, window_width, window_height)
	love.graphics.setColor(255,255,255)
	love.graphics.setFont(mainFont)
	centerText(30,"REALLY RETIRE??", 200)
	centerText(30,"Press Start: Retire", window_height-50)
	centerText(30,"Press Esc: Don't Retire", window_height-100)
end

function drawTitleScreen()
	drawStartScreen()

	love.graphics.setColor(0,0,0,230)
	love.graphics.rectangle("fill", 0, 0, window_width, window_height)
	titleFont = love.graphics.newFont("prstart.ttf",100)

	love.graphics.setFont(titleFont)
	love.graphics.setColor(255,255,255)
	centerText(100,"RASSLER", 210)
	love.graphics.setColor(0,255,255)
	centerText(100,"RASSLER", 205)
	love.graphics.setColor(255,0,255)
	centerText(100,"RASSLER", 200)
	love.graphics.setFont(statFont)
	love.graphics.setColor(200,200,200,200)
	centerText(20,"release 11", 310)

	love.graphics.setFont(statFont)
	love.graphics.setColor(255,255,255,255)
	love.graphics.print("@philnelson", window_width-200, window_height-40)
	love.graphics.print("philnelson.itch.io", 20, window_height-40)

	love.graphics.setFont(mainFont)
	love.graphics.setColor(255,255,255)
	centerText(30,"PRESS START", 400)
end

function centerText(size, string, y)

	x = (window_width/2) - ((string.len(string) * size)) / 2

	love.graphics.print(string, x, y)
end

function centerButton(size, string, y)

	box_x = 20
	text_x = (window_width/2) - ((string.len(string) * size)) / 2
	box_y = y
	text_y = y
	width = window_width - 40

	love.graphics.setColor(0, 0, 0, 255)
	love.graphics.rectangle( "fill", box_x, box_y, width, 46 )
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.print(string, text_x, 11+text_y)

end

function addButton(size, string, x, y, width)

	BUTTONS[#BUTTONS+1] = {text = string, x = x, y = y, size = size, width = width}

end

function drawCardScreen()
	--love.graphics.setColor(222,222,222)
	--love.graphics.rectangle("fill", 0, 0, window_width, window_height)
	drawHUD()
	
	love.graphics.setFont(mainFont);

	love.graphics.setColor(242,51,51)
	love.graphics.rectangle("fill", 0, 60, window_width, 60)

	love.graphics.setColor(255,255,255)
	centerText(30,"TONIGHT ONLY", 80)

	love.graphics.setColor(0,0,0)
	love.graphics.setFont(secondaryFont);
	love.graphics.print("'" .. player.nickname .. "'", 200, 160)
	love.graphics.setFont(mainFont);
	love.graphics.print(player.name, 200, 190)
	love.graphics.setColor(255,255,255)
	player_image = love.graphics.newImage( "rassler" .. player.image .. ".png" )
	love.graphics.draw(player_image, 50, 135, 0, 0.8, 0.8)

	love.graphics.setColor(242,51,51)
	love.graphics.rectangle("fill", 0, 250, window_width, 50)

	love.graphics.setColor(255,255,255)
	centerText(30,".vs.", 260)
	
	love.graphics.setColor(0,0,0)
	love.graphics.setFont(secondaryFont);
	love.graphics.print("'" .. opponent.nickname .. "'", 200, 340)
	love.graphics.setFont(mainFont);
	love.graphics.print(opponent.name, 200, 370)
	love.graphics.setColor(255,255,255)
	opponent_image = love.graphics.newImage( "rassler" .. opponent.image .. ".png" )
	love.graphics.draw(opponent_image,50, 320, 0, 0.8, 0.8)

	love.graphics.setColor(242,51,51)
	love.graphics.rectangle("fill", 0, 440, window_width, 65)
	love.graphics.setColor(255,255,255,255)
	love.graphics.setFont(secondaryFont);
	centerText(20,match.venue .. ', ' .. territories[CURRENT_TERRITORY].name, 450)
	centerText(20,"Capacity: " .. match.capacity, 480)
	
	love.graphics.setColor(255,255,255,255)
	love.graphics.setFont(mainFont);
	centerText(30,"You will be paid $" .. math.floor(match.pay), 525)
	--love.graphics.print("You're booked to lose.", 80, 510)
	centerText(30,"Press Enter To Prepare", 565)
	love.graphics.setColor(0,0,0,255)
	
end

function makeMatch()

	random_rassler = math.random(1,#territories[CURRENT_TERRITORY]['rasslers'])
	newOpponent = territories[CURRENT_TERRITORY]['rasslers'][random_rassler]

	venue = generateVenue()
	capacity = math.floor(generateCapacity())
	attendence = math.floor( ((territories[CURRENT_TERRITORY].fans) * (territories[CURRENT_TERRITORY].popularity * 0.1)) )

	if attendence > capacity then
		attendence = capacity
	end
	
	opponent = newOpponent

	player_pay = (1 * player.technical) * (attendence /100)

	if player_pay < 20 then
		player_pay = 20
	end

	match = {venue=venue, capacity = capacity, attendence = attendence, opponent = newOpponent, pay = player_pay }

	return match
end

function generateCapacity()
	return math.random(100,1000)
end

function generateVenue()
	
	firstNames = {"Cow","Wrestle","Sports","Town","Little","War Memorial","Reed","Serling","Local","Owl Creek","Smoky Hallows"}
	lastNames = {"Center","Dome","Barn","Bar","Club","Auditorium","Hall","Assembly","Church","Fairground"}
	
	return firstNames[math.random(1,tablelength(firstNames))] .. ' ' .. lastNames[math.random(1,tablelength(lastNames))]
	
end

function drawHUD()
	
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle( "fill", 0, 0, 800, 60 )
	
	love.graphics.setColor(255,255,255)
	love.graphics.setFont(statFont)
	love.graphics.print("HEALTH", 10, 10)
	love.graphics.print(math.floor(player.health) .. " / " .. math.floor(player.max_health), 10, 40)
	
	love.graphics.print("AGE", 180, 10)
	love.graphics.print(math.floor(player.age), 180, 40)

	love.graphics.print("ATH", 270, 10)
	love.graphics.print(math.floor(player.athletics), 330, 10)

	love.graphics.print("STR", 270, 40)
	love.graphics.print(math.floor(player.strength), 330, 40)

	love.graphics.print("TECH", 390, 10)
	love.graphics.print(math.floor(player.technical), 470, 10)

	love.graphics.print("SHOW", 390, 40)
	love.graphics.print(math.floor(player.showmanship), 470, 40)

	--love.graphics.print("DAY", 470, 10)
	--love.graphics.print(math.floor(day), 470, 40)
	
	love.graphics.print("FANS", 570, 10)
	love.graphics.print(math.floor(player.popularity), 570, 40)
	
	love.graphics.print("$", 680, 10)
	love.graphics.print(math.floor(player.money), 680, 40)
	
	love.graphics.setColor(255,255,255)
	
end

function drawActivityResultScreen()
	drawHUD()
	
	love.graphics.setColor(0,0,0)
	
	love.graphics.print("Press Enter To Continue", 100,560)
end

function drawResultScreen()
	drawHUD()
	
	love.graphics.setColor(240,240,240)

	love.graphics.rectangle( "fill", 0, 0, window_width, window_height-60 )

	love.graphics.setColor(220,220,220)

	love.graphics.rectangle( "fill", 0, 30, window_width, 50 )

	love.graphics.setColor(0,0,0)

	love.graphics.setFont(statFont)

	love.graphics.print("The Guide to Grappling", 10, 10)
	love.graphics.print("50 Cents / 75 Canadian", 440, 10)
	
	love.graphics.setFont(mainFont)

	centerText(30,"The Wrestling News", 45)

	love.graphics.setFont(headlineFont)
	love.graphics.print("Matches Draw " .. match.attendence .. " Fans", 20, 100)
	love.graphics.print("To " .. match.venue, 20,130)
	--love.graphics.print("Capacity: " .. match.capacity, 200,280)
	--love.graphics.print("Attendence: " .. match.attendence, 200,320)
	
	love.graphics.setColor(255,255,255)
	love.graphics.draw(opponent_image,50, 250, 0, 0.8, 0.8)
	love.graphics.setColor(0,0,0)

	love.graphics.setFont(secondaryFont)
	love.graphics.print(opponent.name, 40,380)
	love.graphics.print("defeats", 40,420)
	love.graphics.print(player.name , 40,460)

	love.graphics.setColor(255,255,255)
	love.graphics.draw(player_image,420, 250, 0, 0.8, 0.8)

	love.graphics.setColor(0,0,0)
	love.graphics.print("Health: ".. MATCHES[#MATCHES].health - MATCHES[#MATCHES-1].health, 420,380)
	love.graphics.print("Fans: " .. MATCHES[#MATCHES].popularity - MATCHES[#MATCHES-1].popularity, 420,420)

	love.graphics.print("You were paid $" ..  math.floor(match.pay), 420,460)
	
	love.graphics.setFont(mainFont)
	love.graphics.setColor(255,255,255)
	love.graphics.print("Press Enter To Exit Arena", 25,560)
	
end

function drawMatchScreen()
	
	drawHUD()
	
	love.graphics.setColor(0,0,0)
	
	love.graphics.print("The " .. match.venue, 200,100)
	love.graphics.print("Capacity: " .. match.capacity, 200,160)
	love.graphics.print("Attendence: " .. match.attendence, 200,190)
	
	if current_work_mode == 1 then
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle( "fill", 30, 320, 175, 30 )
		love.graphics.setColor(0,0,0)
	end
	
	if current_work_mode == 2 then
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle( "fill", 30, 350, 110, 30 )
		love.graphics.setColor(0,0,0)
	end
	
	if current_work_mode == 3 then
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle( "fill", 30, 380, 210, 30 )
		love.graphics.setColor(0,0,0)
	end
	
	love.graphics.print("How do you want to wrestle this match?", 40,280)
	love.graphics.print("Go All Out (Lose 1-" .. WORK_MODES[1].health .. " health, Gain most fans)", 40,330)
	love.graphics.print("Normal (Lose 1-" .. WORK_MODES[2].health .. " health, Gain some fans)", 40,360)
	love.graphics.print("Take It Easy (Lose 1-" .. WORK_MODES[3].health .. " , Gain fewest fans)", 40,390)
	
	love.graphics.print("Up/Down: Select option. Enter: Do It", 100,560)
	
end

function drawRoadScreen()
	drawHUD()
	
	love.graphics.setColor(0,0,0)
	love.graphics.print("You have some free time after the match.", 30,130)
	
	if current_activity_choice == 1 then
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle( "fill", 20, 230, 420, 30 )
		love.graphics.setColor(0,0,0)
	end
	
	if current_activity_choice == 2 then
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle( "fill", 20, 295, 420, 30 )
		love.graphics.setColor(0,0,0)
	end
	
	if current_activity_choice == 3 then
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle( "fill", 20, 355, 420, 30 )
		love.graphics.setColor(0,0,0)
	end
	
	if current_activity_choice == 4 then
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle( "fill", 20, 415, 420, 30 )
		love.graphics.setColor(0,0,0)
	end
	
	if current_activity_choice == 5 then
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle( "fill", 20, 475, 420, 30 )
		love.graphics.setColor(0,0,0)
	end
	
	love.graphics.print("What do you want to do?", 30,200)
		
	love.graphics.print("Take pain meds -$40", 30,240)
	love.graphics.setColor(255,255,255)
	love.graphics.print("+" .. ACTIVITIES[1].health .. " Health, " .. ACTIVITIES[1].max_health .. " Max Health", 30,275)
	
	love.graphics.setColor(0,0,0)
	love.graphics.print("Hit the town -$40", 30,305)
	love.graphics.setColor(255,255,255)
	love.graphics.print(ACTIVITIES[2].health .. " health, gain ".. ACTIVITIES[2].popularity .. " fans", 30,335)
	
	love.graphics.setColor(0,0,0)
	love.graphics.print("Go to work +$20", 30,365)
	love.graphics.setColor(255,255,255)
	love.graphics.print(ACTIVITIES[3].health .. " health", 30,395)
	
	love.graphics.setColor(0,0,0)
	love.graphics.print("Stay in -$5", 30,425)
	love.graphics.setColor(255,255,255)
	love.graphics.print("No effect", 30,455)
	
	love.graphics.setColor(0,0,0)
	love.graphics.print("Retire", 30,485)
	love.graphics.setColor(255,255,255)
	love.graphics.print("End your career", 30,515)

	
	love.graphics.print("Up/Down: Select option. Enter: Do It", 100,560)
end

function drawPrematchScreen()
	drawHUD()
	
	love.graphics.setColor(0,0,0)
	love.graphics.print("You have some free time before the match.", 30,130)
	
	if current_activity_choice == 1 then
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle( "fill", 20, 230, 420, 30 )
		love.graphics.setColor(0,0,0)
	end
	
	if current_activity_choice == 2 then
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle( "fill", 20, 295, 420, 30 )
		love.graphics.setColor(0,0,0)
	end
	
	if current_activity_choice == 3 then
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle( "fill", 20, 355, 420, 30 )
		love.graphics.setColor(0,0,0)
	end
	
	if current_activity_choice == 4 then
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle( "fill", 20, 415, 420, 30 )
		love.graphics.setColor(0,0,0)
	end
	
	if current_activity_choice == 5 then
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle( "fill", 20, 475, 420, 30 )
		love.graphics.setColor(0,0,0)
	end
	
	love.graphics.print("What do you want to do?", 30,200)
		
	love.graphics.print("Take pain meds -$40", 30,240)
	love.graphics.setColor(255,255,255)
	love.graphics.print("+" .. PRE_ACTIVITIES[1].health .. " Health, " .. PRE_ACTIVITIES[1].max_health .. " Max Health", 30,275)
	
	love.graphics.setColor(0,0,0)
	love.graphics.print("Hit the town -$40", 30,305)
	love.graphics.setColor(255,255,255)
	love.graphics.print(PRE_ACTIVITIES[2].health .. " health, gain ".. PRE_ACTIVITIES[2].popularity .. " fans", 30,335)
	
	love.graphics.setColor(0,0,0)
	love.graphics.print("Hit the gym -$60", 30,365)
	love.graphics.setColor(255,255,255)
	love.graphics.print("+" .. PRE_ACTIVITIES[3].health .. " health", 30,395)
	
	love.graphics.setColor(0,0,0)
	love.graphics.print("Stay in -$5", 30,425)
	love.graphics.setColor(255,255,255)
	love.graphics.print("No effect", 30,455)
	
	love.graphics.setColor(0,0,0)
	love.graphics.print("Retire", 30,485)
	love.graphics.setColor(255,255,255)
	love.graphics.print("End your career", 30,515)

	
	love.graphics.print("Up/Down: Select option. Enter: Do It", 100,560)
end

function drawEndScreen()
	drawHUD()
	
	love.graphics.setColor(0,0,0)
	love.graphics.print("Looks like it's time to hang up the 'ol boots.", 20, 80)
	love.graphics.print("Your career accomplishments: ", 20, 120)

	love.graphics.print("Money earned: $" .. player.money_earned, 20, 160)
	love.graphics.print("Money spent: $" .. player.money_spent, 20, 200)

	love.graphics.print("Money left: $" .. player.money, 20, 240)
	--love.graphics.print("Game Over", 120, 500)

	love.graphics.print("ESC: Quit", 20, 500)
	love.graphics.print("Return: One... More... Game...", 20, 540)
	
end

function drawNewDayScreen()
	drawHUD()

	love.graphics.setColor(0,0,0)
	love.graphics.print("It's a new day, yes it is.", 20, 80)
	--love.graphics.print("Your health changed " .. MATCHES[#MATCHES].health - MATCHES[#MATCHES-1].health .. " overnight.", 20, 120)
	love.graphics.print("Your next match is against " .. opponent.name, 20, 150)

	love.graphics.setFont(mainFont)
	love.graphics.setColor(255,255,255)
	love.graphics.print("Press Enter To Continue", 60, 565)
end

function drawStartScreen()

	-- RasslerCard front bottom primary bg
	love.graphics.setColor(240,240,240)
	love.graphics.rectangle( "fill", 20, 60, 320, 400 )

	-- RasslerCard front bottom secondary color
	love.graphics.setColor(10,10,10)
	love.graphics.rectangle( "fill", 20, 455, 320, 50 )

	-- RasslerCard top logo left color
	love.graphics.setColor(0,255,255)
	love.graphics.rectangle( "fill", 20, 60, 10, 30 )

	-- RasslerCard top logo right color
	love.graphics.setColor(255,0,255)
	love.graphics.rectangle( "fill", 30, 60, 10, 30 )

	-- RasslerCard top stripe
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle( "fill", 40, 60, 300, 30 )

	love.graphics.setColor(50,50,50)
	love.graphics.rectangle( "fill", 40, 110, 280, 300 )

	-- RasslerCard back primary bg
	love.graphics.setColor(50,50,50)
--	love.graphics.rectangle( "fill", 380, 120, 320, 310 )

	love.graphics.setColor(240,240,240)
--	love.graphics.rectangle( "fill", 20, 370, 320, 90 )
	
	love.graphics.setColor(10,10,10)
--	love.graphics.rectangle( "fill", 20, 410, 320, 50 )
	
	love.graphics.setColor(0,255,255)
--	love.graphics.rectangle( "fill", 20, 130, 10, 20 )
	
	love.graphics.setColor(255,0,255)
--	love.graphics.rectangle( "fill", 30, 130, 10, 20 )
	
	love.graphics.setColor(0,0,0)
--	love.graphics.rectangle( "fill", 40, 130, 300, 20 )

	love.graphics.setColor(0,0,0)
	love.graphics.setColor(255,255,255)
	love.graphics.setFont(mainFont)

	if SCREENSHOT_MODE == false then
		love.graphics.print("Choose Your Wrestler", 20, 20)
	end
	

	love.graphics.setFont(tinyFont)
	love.graphics.print("RassleCards", 50, 70)

	love.graphics.setFont(statFont)
	love.graphics.print("Health", 420, 140)
	love.graphics.print("/ Max", 560, 140)
	love.graphics.print("Money", 420, 210)
	love.graphics.print("Athletics", 560, 210)
	love.graphics.print("Strength", 420, 260)
	love.graphics.print("Technical", 560, 260)
	love.graphics.print("Showmanship", 420, 310)
	love.graphics.print("Favorite move:", 420, 380)
	--love.graphics.print("Hometown:", 420, 380)
	
	love.graphics.print(player.health, 420, 160)
	love.graphics.print("/ " .. player.max_health, 560, 160)
	love.graphics.print(player.money, 420, 230)
	love.graphics.print(player.athletics, 560, 230)
	love.graphics.print(player.strength, 420, 280)
	love.graphics.print(player.technical, 560, 280)
	love.graphics.print(player.showmanship, 420, 330)
	love.graphics.printf( player.favorite_move, 420, 410, 270, "left" )
	--love.graphics.printf( player.hometown, 420, 410, 270, "left" )

	love.graphics.setFont(mainFont)
	love.graphics.setColor(255,255,255,255)

	if SCREENSHOT_MODE == false then
		centerText(30,"Press Space: New Rassler",520)

		--centerButton(30,"New Rassler", 520)

		--addButton(30, "New Rassler", 0 ,520, window_width/2-10)
		--addButton(30, "Start Game", (window_width/2)+20, 520, (window_width/2) - 10)

		centerText(30,"Press Enter: Start", 560)
	end
	love.graphics.setColor(0,0,0,255)
	
	love.graphics.setColor(255,255,255)
	newFont = love.graphics.newFont("prstart.ttf",autoScaleTextToWidthWithMax(player.name, 320, 24));
	love.graphics.setFont(newFont, 300);
	love.graphics.print(player.name, 30, 470)

	love.graphics.setColor(0,0,0)
	newFont = love.graphics.newFont("prstart.ttf",autoScaleTextToWidthWithMax(player.nickname, 320, 16));
	love.graphics.setFont(newFont, 300);
	love.graphics.print("'" .. player.nickname .. "'", 30, 430)
	
	love.graphics.setFont(mainFont)
	love.graphics.setColor(255,255,255,255)
	
	player_image = love.graphics.newImage( "rassler" .. player.image .. ".png" )
	
	love.graphics.draw(player_image, 120, 200)
end

function autoScaleTextToWidthWithMax(input, box_width, max)
	size = (box_width / (string.len(input)+3))
	if(size > max) then
		size = max
	end
	return size
end

function love.keyreleased(key)
	
	handleKeyPress(key, CURRENT_SCREEN)
   
end

function love.mousepressed(x, y, button, istouch)
	--love.system.openURL("https://philnelson.itch.io/rassler")
end

function handleKeyPress(key, currentScreen)
	
	if key == "d" then
		CURRENT_SCREEN = "debug"
	end

	if key == "s" then
		if currentScreen == "start" then
			SCREENSHOT_MODE = true
			saveScreenShot()
			SCREENSHOT_MODE = false
		end
	end

	if key == "p" then
		local screenshot = love.graphics.newScreenshot();
    	screenshot:encode('png', 'screenshot_' .. os.time() .. '.png');
	end
	
	if key == "return" then
		if currentScreen == "gameOverConfirm" then
			CURRENT_SCREEN = "gameOver"
		end

		if currentScreen == "gameOver" then
			 love.load()
		end

		if currentScreen == "title" then
			CURRENT_SCREEN = "start"
		end
		if currentScreen == "start" then
			current_territory_choice = 1
			CURRENT_SCREEN = "territorySelect"
		end
		if currentScreen == "card" then
			MATCHES[#MATCHES+1] = {screen = currentScreen, health = player.health, popularity = player.popularity, age = player.age, money = player.money, match = match, opponent=opponent}
			
			CURRENT_SCREEN = "match"
		end
		
	    if currentScreen == "match" then

	    	RETURN_TO = "result"

			health_change = math.floor(math.random(1,WORK_MODES[current_work_mode].health))
			popularity_change = 0

			popularity_roll = math.random(1,4)

			-- 3 levels of fan attachment
			if popularity_roll == 1 then
				popularity_change = math.random(1,(match.attendence/10))
			end

			if popularity_roll == 2 or popularity_roll == 3 then
				popularity_change = math.random(1,(match.attendence/7))
			end

			if popularity_roll == 4 then
				popularity_change = math.random(1,match.attendence/5)
			end

			player.health = player.health - health_change

			if((player.popularity + popularity_change) > 0) then
				player.popularity = player.popularity + popularity_change
			else
				player.popularity = 0;
			end

			player.money = player.money + match.pay

			player.money_earned = player.money_earned + match.pay

			player.age = player.age + (0.033)

			MATCHES[#MATCHES+1] = {screen = currentScreen, health = player.health, popularity = player.popularity, age = player.age, money = player.money, match = match, opponent=opponent}

			savePlayerStatus()

			random_event_roll = math.random(1,20)
			if random_event_roll > 15 then
				CURRENT_RANDOM_EVENT = RANDOM_MATCH_EVENTS[math.random(1,#RANDOM_MATCH_EVENTS)]

				-- Apply effects of selected event before changing screens
				player.max_health = player.max_health + CURRENT_RANDOM_EVENT.max_health

	 			if (player.health + CURRENT_RANDOM_EVENT.health) > player.max_health then
	 				player.health = player.max_health
	 				
	 			else
	 				player.health = player.health + CURRENT_RANDOM_EVENT.health
	 			end
	 			
 				if CURRENT_RANDOM_EVENT.money == "-half" then
					money_effect = player.money * 0.5
				else
					money_effect = CURRENT_RANDOM_EVENT.money
				end

				if money_effect > 0 then
					player.money = player.money + money_effect
				else
					player.money = player.money - money_effect
				end

				if((player.popularity + CURRENT_RANDOM_EVENT.popularity) > 0) then
	 				player.popularity = player.popularity + CURRENT_RANDOM_EVENT.popularity
	 			else
	 				player.popularity = 0
	 			end

				CURRENT_SCREEN = "randomEvent"
			else
				CURRENT_SCREEN = "result"
			end
	    end
		
		if currentScreen == "result" then
			current_activity_choice = 1
			CURRENT_SCREEN = "road"
		end
		
	    if currentScreen == "road" then

	    	if current_activity_choice == 5 then
				RETURN_TO = "road"
				CURRENT_SCREEN = "gameOverConfirm"
			else

		    	can_do_activity = false
				
				-- The check here is "do we have negative money? if not, proceed."
		 		if (player.money - math.abs(ACTIVITIES[current_activity_choice].money)) > 0 then

		 			-- Does this damage our health?
		 			if (ACTIVITIES[current_activity_choice].health < 0) then
		 				-- If it does, we can't do it while our health is <= 0. We can only do helath-positive things then.
		 				if (player.health <= 0) or ((player.health - math.abs(ACTIVITIES[current_activity_choice].health)) < 0) then
		 				else
		 					can_do_activity = true
		 				end
		 			else

		 				if (player.health + ACTIVITIES[current_activity_choice].health) > 0 then
		 					can_do_activity = true
		 				end
		 				
		 			end

		 			if can_do_activity == true then
			 			player.max_health = player.max_health + ACTIVITIES[current_activity_choice].max_health

			 			if (player.health + ACTIVITIES[current_activity_choice].health) > player.max_health then
			 				
			 				player.health = player.max_health
			 			else
			 				player.health = player.health + ACTIVITIES[current_activity_choice].health
			 			end
			 			
			 			if(ACTIVITIES[current_activity_choice].money > 0) then
			 				player.money = player.money + ACTIVITIES[current_activity_choice].money
			 			else
			 				player.money = player.money - math.abs(ACTIVITIES[current_activity_choice].money)
			 			end
			 			

			 			player.money_spent = player.money_spent + ACTIVITIES[current_activity_choice].money

			 			player.popularity = player.popularity + ACTIVITIES[current_activity_choice].popularity

			 			MATCHES[#MATCHES+1] = {screen = currentScreen, health = player.health, popularity = player.popularity, age = player.age, money = player.money, match = match}
				
			 			match = makeMatch()

						day = day+1
						CURRENT_SCREEN = "newday"
					

			 		end

				end
			end
		
	 	end

	 	if currentScreen == "newday" then
			current_activity_choice = 1
	 		CURRENT_SCREEN = "prematch"
	 	end

	 	if currentScreen == "territorySelect" then
	 		CURRENT_TERRITORY = current_territory_choice

	 		match = makeMatch()

			current_work_mode = 1
			matchBell:setVolume(0.1)
			matchBell:play()

			
	 		CURRENT_SCREEN = "card"
	 	end

		if currentScreen == "randomEvent" then
			current_activity_choice = 1
	 		CURRENT_SCREEN = RETURN_TO
	 	end

	 	if currentScreen == "prematch" then

	 		if current_activity_choice == 5 then
				RETURN_TO = "prematch"
 				CURRENT_SCREEN = "gameOverConfirm"
 			else

		 		RETURN_TO = "card"

		 		can_do_activity = false

		 		if (PRE_ACTIVITIES[current_activity_choice].money < 0) then
			 		money_comparison = player.money - math.abs(PRE_ACTIVITIES[current_activity_choice].money)
			 	else
			 		money_comparison = player.money + PRE_ACTIVITIES[current_activity_choice].money
			 	end

			 	-- Can we afford this?
		 		if money_comparison > 0 then

		 			-- Does this damage our health?
		 			if (PRE_ACTIVITIES[current_activity_choice].health < 0) then
		 				-- If it does, we can't do it while our health is <= 0. We can only do helath-positive things then.
		 				if (player.health <= 0) or ((player.health - math.abs(PRE_ACTIVITIES[current_activity_choice].health)) < 0) then
		 				else
		 					can_do_activity = true
		 				end
		 			else

		 				if (player.health + PRE_ACTIVITIES[current_activity_choice].health) > 0 then
		 					can_do_activity = true
		 				end
		 				
		 			end

		 			if can_do_activity == true then
		 			
			 			if (player.health + PRE_ACTIVITIES[current_activity_choice].health) > player.max_health then
			 				player.health = player.max_health
			 			else
			 				player.health = player.health + PRE_ACTIVITIES[current_activity_choice].health
			 			end
			 			
			 			player.max_health = player.max_health + PRE_ACTIVITIES[current_activity_choice].max_health

			 			if(PRE_ACTIVITIES[current_activity_choice].money < 0) then
				 			player.money = player.money - math.abs(PRE_ACTIVITIES[current_activity_choice].money)
				 		else
				 			player.money = player.money + math.abs(PRE_ACTIVITIES[current_activity_choice].money)
				 		end
			 			
			 			player.money_spent = player.money_spent + PRE_ACTIVITIES[current_activity_choice].money
			 			player.popularity = player.popularity + PRE_ACTIVITIES[current_activity_choice].popularity

						random_event_roll = math.random(1,20)
						if random_event_roll > 15 then
							CURRENT_RANDOM_EVENT = RANDOM_GYM_EVENTS[math.random(1,#RANDOM_GYM_EVENTS)]

							-- Apply effects of selected event before changing screens
							player.max_health = player.max_health + CURRENT_RANDOM_EVENT.max_health

				 			if (player.health + CURRENT_RANDOM_EVENT.health) > player.max_health then
				 				player.health = player.max_health
				 				
				 			else
				 				player.health = player.health + CURRENT_RANDOM_EVENT.health
				 			end
				 			
			 				if CURRENT_RANDOM_EVENT.money == "-half" then
								money_effect = ((player.money * 0.5) - player.money)
							else
								money_effect = CURRENT_RANDOM_EVENT.money
							end

							if money_effect > 0 then
								player.money = player.money + money_effect
							else
								player.money = player.money - money_effect
							end

							if((player.popularity + CURRENT_RANDOM_EVENT.popularity) > 0) then
				 				player.popularity = player.popularity + CURRENT_RANDOM_EVENT.popularity
				 			else
				 				player.popularity = 0
				 			end

							CURRENT_SCREEN = "randomEvent"
						else
							CURRENT_SCREEN = "card"
						end
					end
				end
			end
	 	end
	end
	
	if key == "space" then
		if currentScreen == "start" then
			player = generateRassler(1)
		end

		if currentScreen == "territorySelect" then
			CURRENTLY_SELECTED_TERRITORY = current_territory_choice
			CURRENT_SCREEN = "territoryInfo"
			RETURN_TO = "territorySelect" 
		end
	end

	if key == "up" then
		if currentScreen == "match" then
			if current_work_mode > 1 then
				current_work_mode = current_work_mode - 1
			else
				current_work_mode = 3
			end
		end
		
		if currentScreen == "road" then
  		   if current_activity_choice > 1 then
  			   current_activity_choice = current_activity_choice - 1
  		   else
  			   current_activity_choice = 5
  		   end
		end

		if currentScreen == "prematch" then
  		   if current_activity_choice > 1 then
  			   current_activity_choice = current_activity_choice - 1
  		   else
  			   current_activity_choice = 5
  		   end
		end

		if currentScreen == "territorySelect" then
			if current_territory_choice > 1 then
  			   current_territory_choice = current_territory_choice - 1
  		   else
  			   current_territory_choice = #territories
  		   end	
		end
	end

	if key == "down" then
		if currentScreen == "match" then
			if current_work_mode < 3 then
				current_work_mode = current_work_mode + 1
			else
				current_work_mode = 1
			end
		end
		
		if currentScreen == "road" then
  		   if current_activity_choice < 5 then
  			   current_activity_choice = current_activity_choice + 1
  		   else
  			   current_activity_choice = 1
  		   end	
		end

		if currentScreen == "prematch" then
  		   if current_activity_choice < 5 then
  			   current_activity_choice = current_activity_choice + 1
  		   else
  			   current_activity_choice = 1
  		   end	
		end

		if currentScreen == "territorySelect" then
			if current_territory_choice < #territories then
  			   current_territory_choice = current_territory_choice + 1
  		   else
  			   current_territory_choice = 1
  		   end	
		end
	end

	if key == "escape" then
		if currentScreen == "gameOverConfirm" then
			CURRENT_SCREEN = RETURN_TO
		end

		if currentScreen == "territoryInfo" then
			CURRENT_SCREEN = RETURN_TO
		end

		if currentScreen == "gameOver" then
			love.event.quit()
		end
	end
end

function generateRasslerNickname()

	name_style = math.random(1,3)

	nickfirst = math.random(1,tablelength(nicknamesFirst))
	nicklast = nickfirst

	while nickfirst == nicklast do
		nicklast = math.random(1,tablelength(nicknamesLast))
	end

	if name_style == 1 then
		nickname = "The " .. nicknamesFirst[nickfirst] .. ' ' .. nicknamesLast[nicklast]
	end

	if name_style == 2 then
		nickname = nicknamesFirst[nickfirst]
	end

	if name_style == 3 then
		nickname = "The " .. nicknamesLast[nicklast]
	end

	return nickname
end

function generateTerritoryName()

	local canUse = true

	while canUse == true do
		name_style = math.random(1,2)

		townFirst = math.random(1,tablelength(townNamesFirst))
		townLastFirst = townFirst
		townLastLast = townFirst

		while townFirst == townLastFirst do
			townLastFirst = math.random(1,tablelength(townNamesLastFirst))
			townLastLast = math.random(1,tablelength(townNamesLastLast))
		end

		if name_style == 1 then
			townName = townNamesFirst[townFirst] .. " " .. townNamesLastFirst[townLastFirst] .. townNamesLastLast[townLastLast]
		end

		if name_style == 2 then
			townName = townNamesLastFirst[townLastFirst] .. townNamesLastLast[townLastLast]
		end

		for i = 1, #territories do
			if territories[i].name == townName then
				canUse = false
			end
		end

		return townName
	end
end

function generateFavoriteMove()
	name_style = math.random(1,3)

	nickfirst = math.random(1,tablelength(moveNamesFirst))
	nicklast = nickfirst

	modFirst = math.random(1,tablelength(moveNamesMods))
	modLast = modFirst

	while nickfirst == nicklast do
		nicklast = math.random(1,tablelength(moveNamesLast))
	end

	while modFirst == modLast do
		modLast = math.random(1,tablelength(moveNamesMods))
	end

	if name_style == 1 then
		nickname = moveNamesFirst[nickfirst] .. "-" .. moveNamesLast[nicklast]
	end

	if name_style == 2 then
		nickname = moveNamesMods[modFirst] .. " " .. moveNamesFirst[nickfirst] .. moveNamesLast[nicklast]
	end

	if name_style == 3 then
		nickname = moveNamesMods[modFirst] .. " " .. moveNamesMods[modLast] .. " " .. moveNamesFirst[nickfirst] .. moveNamesLast[nicklast]
	end

	return nickname
end

function generateRasslerName()
	
	-- When we generate any new name, let's make sure that we haven't already used it. This can cause a lock-up if we run out of names!

	if tablelength(namesFirst) == 0 or tablelength(namesLast) == 0 then
		return "Joe Junkpan"
	else
		-- assume the name we guessed has already been used
		goodName = false

		while goodName == false do
			newName = namesFirst[math.random(1,tablelength(namesFirst))] .. ' ' .. namesLast[math.random(1,tablelength(namesLast))]
			match = false

			for i = 1, #territories do
				for j = 1, #territories[i]['rasslers'] do
					if territories[i]['rasslers'][j]['name'] == newName then
						match = true
					end
				end
			end

			if match == false then
				goodName = true
			end

		end

		return newName
	end
	
	
end

function randomOutsideEventRoll()
	roll = math.floor(math.random(1,20))

	if roll > 17 then
		return true
	end

	return false
end

function getRandomOutsideEvent()
	event = math.floor(math.random(1,#RANDOM_EVENTS))

	return RANDOM_EVENTS[event]
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end

function generate_uuid()
    local template ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'
    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)
        return string.format('%x', v)
    end)
end

function spairs(t, order)
    -- collect the keys
    local keys = {}
    for k in pairs(t) do keys[#keys+1] = k end

    -- if order function given, sort by it by passing the table and keys a, b,
    -- otherwise just sort the keys 
    if order then
        table.sort(keys, function(a,b) return order(t, a, b) end)
    else
        table.sort(keys)
    end

    -- return the iterator function
    local i = 0
    return function()
        i = i + 1
        if keys[i] then
            return keys[i], t[keys[i]]
        end
    end
end