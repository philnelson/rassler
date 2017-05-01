CURRENT_SCREEN = "start"
ACTIVITIES = {}
ACTIVITIES[1] = {name = "Take drugs", health = 6, money = 40, max_health = -6, popularity = 0}
ACTIVITIES[2] = {name = "Hit the town", health = -6, money = 40, max_health = -1, popularity = 5}
ACTIVITIES[3] = {name = "Hit the gym", health = 6, money = 60, max_health = 0, popularity = 0}
ACTIVITIES[4] = {name = "Stay in", health = 1, money = 5, max_health = 0, popularity = 0}
ACTIVITIES[5] = {name = "Retire", health = 0, money = 0, max_health = 0, popularity = 0}

WORK_MODES = {}
WORK_MODES[1] = {name = "Go All Out", health = 20, popularity = 20}
WORK_MODES[2] = {name = "Normal", health = 12, popularity = 12}
WORK_MODES[3] = {name = "Take It Easy", health = 6, popularity = 6}

MATCHES = {}

CURRENT_MATCH = 0

function love.load()
	window_width = 800
	window_height = 600
	math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6)) )
	love.window.setMode( window_width, window_height )
	love.graphics.setDefaultFilter("nearest", "nearest", 0)
	mainFont = love.graphics.newFont("prstart.ttf",30)
	secondaryFont = love.graphics.newFont("prstart.ttf",20)
	statFont = love.graphics.newFont("prstart.ttf",16)
	
	menuMusic = love.audio.newSource("menu.ogg")
	matchBell = love.audio.newSource("sounds/matchBell.ogg")

	day = 1
	
	love.graphics.setFont(mainFont);
	
	rasslers = 19
	
	player_starting_max_health = math.random(70,100)
	player_starting_health = math.random(70,player_starting_max_health)
	player_starting_money = math.random(50,100)
	
	player = {name = generateRasslerName(), image = generateRassler(), nickname = generateRasslerNickname(), skill = 1, health = player_starting_health, max_health = player_starting_max_health, popularity = 0, matches = 0, age = 20, money = player_starting_money, money_spent = 0, money_earned = 0}
	opponent = {name = generateRasslerName(), image = generateRassler(), nickname = generateRasslerNickname(), skill = 1, health = 90, matches = 0, age = 20, popularity = 0, matches = 0,  money = 10}
	
	match_history = {}
	
	match = {}
end

function love.update(dt)

end

function love.draw()
	love.graphics.setBackgroundColor(150,150,150)

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
	
	if CURRENT_SCREEN == "gameOver" then
		drawEndScreen()
	end

	if CURRENT_SCREEN == "newday" then
		drawNewDayScreen()
	end
end

function drawDebugScreen()
	is_file = love.filesystem.exists( "world.ras" )
	
	if is_file == false then
		file, errorstr = love.filesystem.newFile( "world.ras", "a" )
	
		newOpponent = {name = generateRasslerName(), image = generateRassler(), nickname = generateRasslerNickname(), skill  = math.random(1,(player.skill*1.2)), health = math.random(40,100), matches = 0, age = math.random(1,100), popularity = math.random(1,player.popularity*1.2), matches = 0,  money = 0}
	
		success, errormsg = love.filesystem.append( "world.ras", Tserial.pack(newOpponent) )
	
		if success == true then
			love.graphics.setFont(secondaryFont);
			realdir = love.filesystem.getRealDirectory( "world.ras" )
			love.graphics.print("Saved new world file", 0, 0)
		
		else
		
		end
	else
		love.graphics.print("Loaded world file", 0, 0)
	end
end

function drawCardScreen()
	--love.graphics.setColor(222,222,222)
	--love.graphics.rectangle("fill", 0, 0, window_width, window_height)
	drawHUD()
	
	love.graphics.setFont(mainFont);

	love.graphics.setColor(242,51,51)
	love.graphics.rectangle("fill", 0, 60, window_width, 60)

	love.graphics.setColor(255,255,255)
	love.graphics.print("TONIGHT ONLY", 210, 80)

	love.graphics.setColor(0,0,0)
	love.graphics.setFont(secondaryFont);
	love.graphics.print("'The " .. player.nickname .. "'", 200, 160)
	love.graphics.setFont(mainFont);
	love.graphics.print(player.name, 200, 190)
	love.graphics.setColor(255,255,255)
	player_image = love.graphics.newImage( "rassler" .. player.image .. ".png" )
	love.graphics.draw(player_image, 50, 135, 0, 0.8, 0.8)

	love.graphics.setColor(242,51,51)
	love.graphics.rectangle("fill", 0, 250, window_width, 50)

	love.graphics.setColor(255,255,255)
	love.graphics.print(".vs.", 330, 260)
	
	love.graphics.setColor(0,0,0)
	love.graphics.setFont(secondaryFont);
	love.graphics.print("'The " .. opponent.nickname .. "'", 200, 340)
	love.graphics.setFont(mainFont);
	love.graphics.print(opponent.name, 200, 370)
	love.graphics.setColor(255,255,255)
	opponent_image = love.graphics.newImage( "rassler" .. opponent.image .. ".png" )
	love.graphics.draw(opponent_image,50, 320, 0, 0.8, 0.8)

	love.graphics.setColor(242,51,51)
	love.graphics.rectangle("fill", 0, 440, window_width, 65)
	love.graphics.setColor(255,255,255,255)
	love.graphics.setFont(secondaryFont);
	love.graphics.print("At the " .. match.venue, 40, 455)
	love.graphics.print("Capacity: " .. match.capacity, 40, 480)
	
	love.graphics.setColor(255,255,255,255)
	love.graphics.setFont(mainFont);
	love.graphics.print("You will be paid $" .. math.floor(match.pay), 100, 525)
	--love.graphics.print("You're booked to lose.", 80, 510)
	love.graphics.print("Press Enter To Prepare", 70, 565)
	love.graphics.setColor(0,0,0,255)
	
end

function makeMatch()
	
	newOpponent = {name = generateRasslerName(), image = generateRassler(), nickname = generateRasslerNickname(), skill  = math.random(1,(player.skill*1.2)), health = math.random(40,100), matches = 0, age = math.random(1,100), popularity = math.random(1,player.popularity*1.2), matches = 0,  money = 0}
	
	venue = generateVenue()
	capacity = math.floor(generateCapacity())
	attendence = math.floor(math.random(capacity/10,capacity))
	
	opponent = newOpponent

	player_pay = (1 * player.skill) * (attendence /100)

	if player_pay < 20 then
		player_pay = 20
	end
	
	return {venue=venue, capacity = capacity, attendence = attendence, opponent = newOpponent, pay = player_pay }
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
	
	love.graphics.print("SKILL", 250, 10)
	love.graphics.print(math.floor(player.skill), 250, 40)

	love.graphics.print("SPIRIT", 350, 10)
	love.graphics.print(math.floor(player.skill), 350, 40)

	love.graphics.print("DAY", 470, 10)
	love.graphics.print(math.floor(day), 470, 40)
	
	love.graphics.print("FANS", 570, 10)
	love.graphics.print(math.floor(player.popularity), 570, 40)
	
	love.graphics.print("$", 670, 10)
	love.graphics.print(math.floor(player.money), 670, 40)
	
	love.graphics.setColor(255,255,255)
	
end

function drawActivityResultScreen()
	drawHUD()
	
	love.graphics.setColor(0,0,0)
	
	love.graphics.print("Press Enter To Continue", 100,560)
end

function drawResultScreen()
	drawHUD()
	
	love.graphics.setColor(0,0,0)
	
	love.graphics.print("The " .. match.venue, 200,200)
	love.graphics.print("Capacity: " .. match.capacity, 200,280)
	love.graphics.print("Attendence: " .. match.attendence, 200,320)
	
	love.graphics.print("You wrestled against " .. opponent.name, 40,380)
	love.graphics.print("Your health changed by ".. MATCHES[CURRENT_MATCH].health - MATCHES[CURRENT_MATCH-1].health, 40,410)
	love.graphics.print("You were paid $" ..  math.floor(match.pay), 40,470)
	
	love.graphics.setFont(mainFont)
	love.graphics.setColor(255,255,255)
	love.graphics.print("Press Enter To Go Home", 70,560)
	
end

function drawMatchScreen()
	
	drawHUD()
	
	love.graphics.setColor(0,0,0)
	
	love.graphics.print("The " .. match.venue, 200,100)
	love.graphics.print("Capacity: " .. match.capacity, 200,160)
	love.graphics.print("Attendence: " .. match.attendence, 200,190)
	
	if current_work_mode == 1 then
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle( "fill", 70, 320, 175, 30 )
		love.graphics.setColor(0,0,0)
	end
	
	if current_work_mode == 2 then
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle( "fill", 70, 350, 210, 30 )
		love.graphics.setColor(0,0,0)
	end
	
	if current_work_mode == 3 then
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle( "fill", 70, 380, 210, 30 )
		love.graphics.setColor(0,0,0)
	end
	
	love.graphics.print("How hard do you want to wrestle today?", 80,280)
	love.graphics.print("Go All Out " .. WORK_MODES[1].health, 80,330)
	love.graphics.print("Normal " .. WORK_MODES[2].health, 80,360)
	love.graphics.print("Take It Easy " .. WORK_MODES[3].health, 80,390)
	
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
		
	love.graphics.print("Take pain meds - $40", 30,240)
	love.graphics.setColor(255,255,255)
	love.graphics.print(ACTIVITIES[1].health .. " Health, " .. ACTIVITIES[1].max_health .. " Max Health", 30,275)
	
	love.graphics.setColor(0,0,0)
	love.graphics.print("Hit the town - $40", 30,305)
	love.graphics.setColor(255,255,255)
	love.graphics.print(ACTIVITIES[2].health .. " Health, " .. ACTIVITIES[2].max_health .. " Max Health",30,335)
	
	love.graphics.setColor(0,0,0)
	love.graphics.print("Hit the gym - $60", 30,365)
	love.graphics.setColor(255,255,255)
	love.graphics.print(ACTIVITIES[3].health .. " Health, " .. ACTIVITIES[3].max_health .. " Max Health", 30,395)
	
	love.graphics.setColor(0,0,0)
	love.graphics.print("Stay in - $5", 30,425)
	love.graphics.setColor(255,255,255)
	love.graphics.print(ACTIVITIES[4].health .. " Health, " .. ACTIVITIES[4].max_health .. " Max Health", 30,455)
	
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
		
	love.graphics.print("Take pain meds - $40", 30,240)
	love.graphics.setColor(255,255,255)
	love.graphics.print(ACTIVITIES[1].health .. " Health, " .. ACTIVITIES[1].max_health .. " Max Health", 30,275)
	
	love.graphics.setColor(0,0,0)
	love.graphics.print("Hit the town - $40", 30,305)
	love.graphics.setColor(255,255,255)
	love.graphics.print("-4 health, gain some fans", 30,335)
	
	love.graphics.setColor(0,0,0)
	love.graphics.print("Hit the gym - $60", 30,365)
	love.graphics.setColor(255,255,255)
	love.graphics.print("+5 health", 30,395)
	
	love.graphics.setColor(0,0,0)
	love.graphics.print("Stay in - $5", 30,425)
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
	love.graphics.print("Game Over", 20, 600)
	
end

function drawNewDayScreen()
	drawHUD()

	love.graphics.setColor(0,0,0)
	love.graphics.print("It's a new day, yes it is.", 20, 80)
	love.graphics.print("You regained 1 health from sleep.", 20, 120)

	love.graphics.setFont(mainFont)
	love.graphics.setColor(255,255,255)
	love.graphics.print("Press Enter To Continue", 60, 565)
end

function drawStartScreen()
	
	love.graphics.setColor(0,0,0)
	love.graphics.setLineWidth( 8 )
	love.graphics.rectangle( "line", 0, 250, 800, 200 )
	love.graphics.setFont(mainFont)
	
	love.graphics.print("So you wanna be a", 20, 20)
	love.graphics.print("wrestler, huh?", 20, 60)
	love.graphics.print("Alright kid, here's what", 20, 120)
	love.graphics.print("we came up with for you.", 20, 160)
	
	love.graphics.setFont(statFont)
	love.graphics.print("Health", 200, 380)
	love.graphics.print("Max Health", 420, 380)
	love.graphics.print("Money", 680, 380)
	
	love.graphics.print(player.health, 200, 400)
	love.graphics.print(player.max_health, 420, 400)
	love.graphics.print(player.money, 680, 400)
	love.graphics.setFont(mainFont)
	
	love.graphics.setColor(255,255,255,255)
	love.graphics.print("Press Enter To Start", 40, 520)
	love.graphics.print("Press Space To Reroll", 40, 560)
	love.graphics.setColor(0,0,0,255)
	
	love.graphics.print(player.name, 230, 320)
	love.graphics.setFont(secondaryFont);
	love.graphics.print("'The " .. player.nickname .. "'", 170, 290)
	
	love.graphics.setFont(mainFont)
	love.graphics.setColor(255,255,255,255)
	
	player_image = love.graphics.newImage( "rassler" .. player.image .. ".png" )
	
	love.graphics.draw(player_image, 40, 290)
end

function love.keyreleased(key)
	
	handleKeyPress(key, CURRENT_SCREEN)
   
end

function handleKeyPress(key, currentScreen)
	
	if key == "d" then
		CURRENT_SCREEN = "debug"
	end
	
	if key == "return" then
		if currentScreen == "start" then
			MATCHES[0] = {health = player.health, popularity = player.popularity, skill = player.skill, age = player.age, money = player.money}

			match = makeMatch()
			current_work_mode = 1
			matchBell:setVolume(0.1)
			matchBell:play()
			CURRENT_SCREEN = "card"
		end
		if currentScreen == "card" then
			CURRENT_SCREEN = "match"
		end
		
	    if currentScreen == "match" then

			health_change = math.random(1,WORK_MODES[current_work_mode].health)
			popularity_change = math.random(1,WORK_MODES[current_work_mode].popularity)*player.skill/2

			player.health = player.health - health_change
			player.popularity = player.popularity + popularity_change

			player.money = player.money + match.pay
			player.money_earned = player.money_earned + match.pay

			player.skill = player.skill + 1

			player.age = player.age + (0.033)

			CURRENT_MATCH = CURRENT_MATCH + 1

			MATCHES[#MATCHES+1] = {health = player.health, popularity = player.popularity, skill = player.skill, age = player.age, money = player.money}

			CURRENT_SCREEN = "result"
	    end
		
		if currentScreen == "result" then
			current_activity_choice = 1
			CURRENT_SCREEN = "road"
		end
		
	    if currentScreen == "road" then
			
	 		if (player.money - ACTIVITIES[current_activity_choice].money) > 0 then
	 			player.health = player.health + ACTIVITIES[current_activity_choice].health
	 			player.max_health = player.max_health + ACTIVITIES[current_activity_choice].max_health
	 			
	 			player.money = player.money - ACTIVITIES[current_activity_choice].money
	 			player.money_spent = player.money_spent + ACTIVITIES[current_activity_choice].money

	 			player.popularity = player.popularity + ACTIVITIES[current_activity_choice].popularity
		
	 			match = makeMatch()
				
				if current_activity_choice == 5 then
	 				CURRENT_SCREEN = "gameOver"
				else
					day = day+1
					CURRENT_SCREEN = "newday"
				end
			end
		
	 	end

	 	if currentScreen == "newday" then
	 		-- heal the player in the night +HEALTH
			healed = math.floor(math.random(1,player.max_health/10))
			if (player.health + healed) > player.max_health then
				player.health = player.max_health
			else
				player.health = player.health + healed
			end
			
			current_activity_choice = 1
	 		CURRENT_SCREEN = "prematch"
	 	end

	 	if currentScreen == "prematch" then
	 		if (player.money - ACTIVITIES[current_activity_choice].money) > 0 then
	 			if (player.health + ACTIVITIES[current_activity_choice].health) > player.max_health then
	 				player.health = player.max_health
	 			else
	 				player.health = player.health + ACTIVITIES[current_activity_choice].health
	 			end
	 			
	 			player.max_health = player.max_health + ACTIVITIES[current_activity_choice].max_health
	 			player.money = player.money - ACTIVITIES[current_activity_choice].money
	 			player.money_spent = player.money_spent + ACTIVITIES[current_activity_choice].money
	 			player.popularity = player.popularity + ACTIVITIES[current_activity_choice].popularity
		
	 			match = makeMatch()
				
				if current_activity_choice == 5 then
	 				CURRENT_SCREEN = "gameOver"
				else
					day = day+1
					CURRENT_SCREEN = "card"
				end
			end
	 	end
	end
	
	if key == "space" then
		if currentScreen == "start" then
			player.name = generateRasslerName()
			player.nickname = generateRasslerNickname()
			player.image = generateRassler()


			player.max_health = math.random(70,100)
			player.health = math.random(70,player.max_health)
			player.money = math.random(50,100)

			opponent.name = generateRasslerName()
			opponent.nickname = generateRasslerNickname()
			opponent.image = generateRassler()
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
	end
end

function generateRasslerNickname()
	
	nicknameStart = {"Wild","Scary","Flying","Super","Violent","High","Wicked","Pretty","Genetic","Demonic","Unstoppable","Dancing","Incredible","Immortal","Rowdy","Screaming","Cruel","Crazy","Angry","Mad","Masked","Grand","Esteemed","Elegant","Smooth-talkin'","Lunatic","Miracle", "Canadian"}
	nicknameEnding = {"Amazon","Goddess","Astronaut","Grappler","Crippler","Stranger","Person","Cowboy","Flyer","Doctor","Wizard","Dervish","Shiek","Gremlin","Wrestler","Beekeeper","Element","Leader","Snake-charmer","Giant","Freak","Star"}
	
	return nicknameStart[math.random(1,tablelength(nicknameStart))] .. ' ' .. nicknameEnding[math.random(1,tablelength(nicknameEnding))]
end

function generateRasslerName()
	
	firstNames = {"Jim","Giant","Hiroshi","Satoru","J.P.","Serena","Venus","Prince","Ed","Kareen","Momar","Linda","Elizabeth","General","Bruce","Ricky","Big","Tracey","Rick","Ric","Rik","Jake","Bobby","Rob","Butch","Randy","Steve","Chris","Thomas","Jack","Greg","Tony","Vikas","Buzz","Sherri","Tina","Blaze","Tonya","Hoss","Li","Sharon","Kiki","Sofia","Renata","Maria"}
	lastNames = {"Strong","Saturn","Yamauchi","Iwata","Swindler","Badd","Blood","Huang","Tsung","Chung","Wu","Nelson","Lewis","Adnan","Bruce","James","Calhoun","Roberts","McGill","Jane","Victory","Adams","Strong","Schwartz","Foreign","Brute","King","Brutal","Johnson","Torrid","Luxury","Benjamin","Swizzle","Sawyer","Kratos"}
	
	return firstNames[math.random(1,tablelength(firstNames))] .. ' ' .. lastNames[math.random(1,tablelength(lastNames))]
	
end

function generateRassler()
	return math.random(1,rasslers)
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end