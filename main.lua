CURRENT_SCREEN = "start"
WORK_MODES = {"Go all out","Play it safe","Be lazy"}
ACTIVITIES = {}
ACTIVITIES[0] = {name = "Take drugs", health = 0, money = -60, max_health = -5, bumps = 5}
ACTIVITIES[1] = {name = "Go out", health = -5, money = -40, max_health = -1, bumps = 0}
ACTIVITIES[2] = {name = "Work out", health = 5, money = -40, max_health = 0, bumps = 0}
ACTIVITIES[3] = {name = "Stay in", health = 1, money = -5, max_health = 0, bumps = 0}
ACTIVITIES[4] = {name = "Retire", health = 0, money = 0, max_health = 0, bumps = 0}
require 'Tserial'

function love.load()
	math.randomseed( tonumber(tostring(os.time()):reverse():sub(1,6)) )
	love.window.setMode( 800, 600 )
	love.graphics.setDefaultFilter("nearest", "nearest", 0)
	mainFont = love.graphics.newFont("prstart.ttf",30)
	secondaryFont = love.graphics.newFont("prstart.ttf",20)
	statFont = love.graphics.newFont("prstart.ttf",16)
	
	menuMusic = love.audio.newSource("menu.ogg")
	
	love.graphics.setFont(mainFont);
	
	love.graphics.setBackgroundColor(150,150,150)
	
	rasslers = 19
	
	player = {name = generateRasslerName(), image = generateRassler(), nickname = generateRasslerNickname(), skill = 1, health = 90, max_health = 100, bumps = 100, popularity = 0, matches = 0, age = 20, money = 10}
	opponent = {name = generateRasslerName(), image = generateRassler(), nickname = generateRasslerNickname(), skill = 1, health = 90, bumps = 100, matches = 0, age = 20, popularity = 0, matches = 0,  money = 10}
	
	match_history = {}
	
	match = {}
	
	menuMusic:setVolume(0.5)
	menuMusic:play()
end

function love.update(dt)

end

function love.draw()
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
end

function drawDebugScreen()
	is_file = love.filesystem.exists( "world.ras" )
	
	if is_file == false then
		file, errorstr = love.filesystem.newFile( "world.ras", "a" )
	
		newOpponent = {name = generateRasslerName(), image = generateRassler(), nickname = generateRasslerNickname(), skill  = math.random(1,(player.skill*1.2)), health = math.random(40,100), bumps = math.random(1,100), matches = 0, age = math.random(1,100), popularity = math.random(1,player.popularity*1.2), matches = 0,  money = 0}
	
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
	drawHUD()
	
	love.graphics.setFont(mainFont);
	
	player_image = love.graphics.newImage( "rassler" .. player.image .. ".png" )
	opponent_image = love.graphics.newImage( "rassler" .. opponent.image .. ".png" )
	
	love.graphics.draw(player_image, 40, 80)
	
	love.graphics.draw(opponent_image,640, 280)
	
	love.graphics.setColor(0,0,0)
	love.graphics.print(".vs.", 300, 230)
	
	love.graphics.print(player.name, 230, 130)
	love.graphics.setFont(secondaryFont);
	love.graphics.print("'The " .. player.nickname .. "'", 230, 90)
	love.graphics.setFont(mainFont);
	
	love.graphics.print(opponent.name, 40, 330)
	love.graphics.setFont(secondaryFont);
	love.graphics.print("'The " .. opponent.nickname .. "'", 40, 300)
	love.graphics.setFont(mainFont);
	
	love.graphics.print("You will be paid $" .. match.pay, 100, 470)
	love.graphics.print("You're booked to lose.", 80, 510)
	love.graphics.setColor(255,255,255,255)
	love.graphics.print("Press N To Get Ready", 40, 550)
	love.graphics.setColor(0,0,0,255)
	
end

function makeMatch()
	
	newOpponent = {name = generateRasslerName(), image = generateRassler(), nickname = generateRasslerNickname(), skill  = math.random(1,(player.skill*1.2)), health = math.random(40,100), bumps = math.random(1,100), matches = 0, age = math.random(1,100), popularity = math.random(1,player.popularity*1.2), matches = 0,  money = 0}
	
	venue = generateVenue()
	place = generatePlace()
	capacity = generateCapacity()
	attendence = math.random(1,capacity)
	
	opponent = newOpponent
	
	return {venue=venue, place = place, capacity = capacity, attendence = attendence, opponent = newOpponent, pay = math.floor(0.1*attendence)*(player.skill) }
end

function simulateMatch(player,opponent)
	
end

function generatePlace()
	
	firstNames = {"Twoson","Onett","Threed","Popcorn","Santa Claus","Niles","Buchanan","Big City"}
	lastNames = {"MI","IL","IA","OH","WI","MN"}
	
	return firstNames[math.random(1,tablelength(firstNames))] .. ', ' .. lastNames[math.random(1,tablelength(lastNames))]
	
end

function generateCapacity()
	return math.random(20,1000)
end

function generateVenue()
	
	firstNames = {"Cow","Wrestle","Sports","Town","Little"}
	lastNames = {"Center","Dome","Barn","Bar","Club","Auditorium"}
	
	return firstNames[math.random(1,tablelength(firstNames))] .. ' ' .. lastNames[math.random(1,tablelength(lastNames))]
	
end

function drawHUD()
	
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle( "fill", 0, 0, 800, 60 )
	
	love.graphics.setColor(255,255,255)
	love.graphics.setFont(statFont)
	love.graphics.print("Health", 10, 10)
	love.graphics.print(player.health, 10, 40)
	
	love.graphics.print("Bumps", 120, 10)
	love.graphics.print(player.bumps, 120, 40)
	
	love.graphics.print("Age", 220, 10)
	love.graphics.print(math.floor(player.age), 220, 40)
	
	love.graphics.print("Skill", 300, 10)
	love.graphics.print(player.skill, 300, 40)
	
	love.graphics.print("Fans", 420, 10)
	love.graphics.print(player.popularity, 420, 40)
	
	love.graphics.print("$", 560, 10)
	love.graphics.print(player.money, 560, 40)
	
	love.graphics.setColor(255,255,255)
	
end

function drawResultScreen()
	drawHUD()
	
	love.graphics.setColor(0,0,0)
	
	love.graphics.print("The " .. match.venue, 200,200)
	love.graphics.print("In " .. match.place, 200,240)
	love.graphics.print("Capacity: " .. match.capacity, 200,280)
	love.graphics.print("Attendence: " .. match.attendence, 200,320)
	
	love.graphics.print("You worked a match against " .. opponent.name, 40,380)
	love.graphics.print("You took " .. match.bumps .. " bumps.", 40,410)
	love.graphics.print("You got " .. match.newFans .. " new fans.", 40,440)
	love.graphics.print("You were paid ", 40,470)
	love.graphics.setColor(255,255,0)
	love.graphics.print("$" .. match.pay, 260,470)
	love.graphics.setColor(0,0,0)
	
	love.graphics.print("Press N To Drive On Down The Road", 100,560)
	
end

function drawMatchScreen()
	
	drawHUD()
	
	love.graphics.setColor(0,0,0)
	
	love.graphics.print("The " .. match.venue, 200,100)
	love.graphics.print("In " .. match.place, 200,130)
	love.graphics.print("Capacity: " .. match.capacity, 200,160)
	love.graphics.print("Attendence: " .. match.attendence, 200,190)
	
	if current_work_mode == 0 then
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle( "fill", 190, 320, 420, 30 )
		love.graphics.setColor(0,0,0)
	end
	
	if current_work_mode == 1 then
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle( "fill", 190, 350, 420, 30 )
		love.graphics.setColor(0,0,0)
	end
	
	if current_work_mode == 2 then
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle( "fill", 190, 380, 420, 30 )
		love.graphics.setColor(0,0,0)
	end
	
	love.graphics.print("How do you want to work?", 200,300)
	love.graphics.print("Go all out (-5 bumps)", 200,330)
	love.graphics.print("Play it safe (-3 bumps)", 200,360)
	love.graphics.print("Bare minimum (-1 bumps)", 200,390)
	
	love.graphics.print("Up/Down: Select option. Enter: Start", 100,560)
	
end

function drawRoadScreen()
	drawHUD()
	
	love.graphics.setColor(0,0,0)
	love.graphics.print("You're in " .. match.place .. ",", 30,130)
	love.graphics.print("and have some free time.", 30,160)
	
	if current_activity_choice == 0 then
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle( "fill", 20, 230, 420, 30 )
		love.graphics.setColor(0,0,0)
	end
	
	if current_activity_choice == 1 then
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle( "fill", 20, 295, 420, 30 )
		love.graphics.setColor(0,0,0)
	end
	
	if current_activity_choice == 2 then
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle( "fill", 20, 355, 420, 30 )
		love.graphics.setColor(0,0,0)
	end
	
	if current_activity_choice == 3 then
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle( "fill", 20, 415, 420, 30 )
		love.graphics.setColor(0,0,0)
	end
	
	if current_activity_choice == 4 then
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle( "fill", 20, 475, 420, 30 )
		love.graphics.setColor(0,0,0)
	end
	
	love.graphics.print("What do you want to do?", 30,200)
		
	love.graphics.print("Take drugs - $60", 30,240)
	love.graphics.setColor(255,255,255)
	love.graphics.print("+5 bumps next match, -1 max health", 30,275)
	
	love.graphics.setColor(0,0,0)
	love.graphics.print("Go out - $40", 30,305)
	love.graphics.setColor(255,255,255)
	love.graphics.print("-5 health", 30,335)
	
	love.graphics.setColor(0,0,0)
	love.graphics.print("Work out - $40", 30,365)
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

	
	love.graphics.print("Up/Down: Select option. Enter: Start", 100,560)
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
	love.graphics.print("Health", 230, 380)
	love.graphics.print("Bumps", 400, 380)
	love.graphics.print("Fans", 600, 380)
	
	love.graphics.print(player.health, 230, 400)
	love.graphics.print(player.bumps, 400, 400)
	love.graphics.print(player.popularity, 600, 400)
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

function love.keypressed(key)
	
	if key == "d" then
		CURRENT_SCREEN = "debug"
	end
	
   if key == " " then
	   player.name = generateRasslerName()
	   player.nickname = generateRasslerNickname()
	   player.image = generateRassler()
	   
	   opponent.name = generateRasslerName()
	   opponent.nickname = generateRasslerNickname()
	   opponent.image = generateRassler()
   end
   
   if CURRENT_SCREEN == "start" then
	   if key == "return" then
		   match = makeMatch()
		   current_work_mode = 0
		   CURRENT_SCREEN = "card"
	   end
   end
   
   if CURRENT_SCREEN == "card" then
	   if key == "n" then
		   CURRENT_SCREEN = "match"
	   end
   end
   
   if CURRENT_SCREEN == "match" then
	   if key == "up" then
		   
		   if current_work_mode >= 1 then
			   current_work_mode = current_work_mode - 1
		   else
			   current_work_mode = 2
		   end
	   end
	   
	   if key == "down" then
		   
		   if current_work_mode <= 1 then
			   current_work_mode = current_work_mode + 1
		   else
			   current_work_mode = 0
		   end
	   end
   end
   
   if CURRENT_SCREEN == "match" then
	   if key == "return" then
		   
		   match.bumps = 1
		   match.newFans = math.floor(match.attendence / ((current_work_mode+1)*4))
		   
		   if current_work_mode == 0 then
			  match.bumps = 5 
		   end
		   
		   if current_work_mode == 1 then
			   match.bumps = 3
		   end   
		   
		   player.money = player.money+match.pay
		   player.popularity = player.popularity+match.newFans
		   player.bumps = player.bumps-match.bumps
		   
		   player.skill = player.skill + 1
		   
		   player.age = player.age + (1/30)
		   
		   player.health = player.health - ((match.bumps*1))
		   
		   CURRENT_SCREEN = "result"
	   end
   end
   
   if CURRENT_SCREEN == "result" then
	    if key == "n" then
			current_activity_choice = 0
			CURRENT_SCREEN = "road"
		end
   end
   
   if CURRENT_SCREEN == "road" then
	    if key == "return" then
			
			if ACTIVITIES[current_activity_choice].money < player.money then
				player.health = player.health + ACTIVITIES[current_activity_choice].health
				player.max_health = player.max_health + ACTIVITIES[current_activity_choice].max_health
				player.money = player.money + ACTIVITIES[current_activity_choice].money
				player.bumps = player.bumps + ACTIVITIES[current_activity_choice].bumps
			
				match = makeMatch()
				CURRENT_SCREEN = "card"
			end
			
		end
		
 	   if key == "up" then
		   
 		   if current_activity_choice >= 1 then
 			   current_activity_choice = current_activity_choice - 1
 		   else
 			   current_activity_choice = 4
 		   end
 	   end
	   
 	   if key == "down" then
		   
 		   if current_activity_choice <= 3 then
 			   current_activity_choice = current_activity_choice + 1
 		   else
 			   current_activity_choice = 0
 		   end
 	   end
		
   end
   
end

function generateRasslerNickname()
	
	nicknameStart = {"Wild","Flying","Violent","High","Wicked","Pretty","Demonic","Unstoppable","Dancing","Incredible","Immortal","Rowdy","Screaming","Cruel","Crazy","Angry","Mad","Masked","Grand","Esteemed","Elegant","Smooth-talkin'","Lunatic","Miracle", "Canadian"}
	nicknameEnding = {"Amazon","Goddess","Astronaut","Grappler","Crippler","Stranger","Person","Cowboy","Flyer","Doctor","Wizard","Dervish","Shiek","Gremlin","Wrestler","Beekeeper","Element","Leader","Snake-charmer"}
	
	return nicknameStart[math.random(1,tablelength(nicknameStart))] .. ' ' .. nicknameEnding[math.random(1,tablelength(nicknameEnding))]
end

function generateRasslerName()
	
	firstNames = {"Hiroshi","Satoru","J.P.","Serena","Venus","Prince","Ed","Kareen","Momar","Linda","Elizabeth","General","Bruce","Ricky","Big","Tracey","Rick","Ric","Rik","Jake","Bobby","Rob","Butch","Randy","Steve","Chris","Thomas","Jack","Greg","Tony","Sherri","Tina","Blaze","Tonya","Hoss","Li","Sharon","Kiki","Sofia","Renata","Maria"}
	lastNames = {"Yamauchi","Iwata","Swindler","Badd","Blood","Huang","Tsung","Chung","Wu","Nelson","Lewis","Adnan","Bruce","James","Calhoun","Roberts","McGill","Jane","Victory","Adams","Strong","Schwartz","Foreign","Brute","King","Brutal","Johnson","Torrid","Luxury","Benjamin","Swizzle"}
	
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