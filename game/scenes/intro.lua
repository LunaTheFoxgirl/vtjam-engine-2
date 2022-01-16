::Introduction::
    -- Starts with a black screen and slowly transitions to Bedroom.Dawn
    scene.bg ""

	-- Apology for the state of the game lol
	think 	"-- This is a game made for VTGameJam2022 --\n\z
			This was made under the time constraint of 48 hours\n\z
			With a custom built engine made from scratch.\n\z
			Parts of the story are probably missing" --
	think	"Free stock backgrounds are provided by\n\z
			- Noraneko Games\n\z
			- MUGEN's Free VN Resources."
	think	"Sorry about that. I hope you will enjoy this taste\n\z
			Of what we wanted to make nontheless\n\z
			- Luna and Nethyr_UX"
	think 	"..."	 

	think   "At a certain age, young boys and girls prepare for a special event:\n\z
            the High School Gala.\n\z
            It’s a Coming of Age Ceremony... of getting lit af!!!\n\z
            And also becoming a young adult."

	think   "Today, we will witness one such girl preparing for the High School Gala...\n\z
            As it is 3 weeks before said High School Gala.\n\z
            Her name is Freja, a young golden eyed puppy, and she is currently asleep."

	goto Scene1

::Scene1::
do
    -- scene.bg "bgs/bedroom"
	-- Starts with Alarm SFX

	-- TODO: Add sound effect in to game/sfx/alarm and uncomment alarm playback code.
	-- local alarm = loadSFX("sfx/alarm")
	-- alarm.looping = true
	
	freja:show()
	freja:move(1)

	-- alarm:play()
	freja [["MMm... I hate alarms.”]]
	-- alarm:stop()
	think [[I open one eye and peer at the clock. It’s 5 am.]]
	
	local result = choice(
        "Should I get more shut eye...? It's just Monday.", {
            "Yes, sleep some more.",
            "No, get up early."
    })
	if result == 1 then
		-- alarm:destroy() -- We don't need it after this point and it's done playing
		goto MoreSleep
	elseif result == 2 then
		-- alarm:destroy() -- We don't need it after this point and it's done playing
		goto LessSleep
    end
end

::MoreSleep::
do
    scene.bg "bgs/bedroom"
	freja   [["Mmm....too early."]]

	scene.bg "" -- TODO: CG here?
	freja:hide()
	think   "I shut my eyes tightly and flump my pillow over my ears.\n\z
		    Naps are the best…I slowly nod off and find myself in a dream."
	
	think   "A girl with red hair and equally red eyes is there. She also has sharp fox ears -\n\z
			she reminds me of my new friend Mathilde…"
	think   "She seems to be happily playing with dolls in a dollhouse.\n\z
			There’s one blonde haired girl and another with brown hair."
	think   [[She’s making them dance and she’s so happy… She has the softest smile.]]

	think   "Then, a taller person - probably her dad- comes in, takes the blonde doll,\n\z
			and replaces it with a blonde boy doll."
	think   "The girl stares at her dad and then back at the doll.\n\z
            She doesn’t make them dance."
	think   "Her smile disappears and just looks away\n\z
            from her dad as his shadow grows over her."
	
	scene.bg "bgs/bedroom"
	freja:show()
	freja:expr "shocked"
	think   "I wake up from my bed in a cold sweat and turn to the clock. It’s 7 am.§p\n\z
            Shit.§p§p I quickly change clothes and run downstairs."
    
    -- Mom is talking
    freja:expr "neutral"
	mom     [["Freja! You're going to be late again!"]]
	
	scene.bg "bgs/livingroom" -- Switching to livingroom
	freja   [["I know! I know!!"]]
	think   [[I take a piece of bread from the kitch counter and put it in my mouth.]]
	
	mom     [["Make sure to get a big lunch, sunflower! Oh and find a date for the Gala!!"]]
	
	think   [[The What??]]
	
	freja   [["Uh, sure, Ma! Cya later"]]
	
	scene.bg "bgs/park_day"
	think   "I slip on my sneakers and run off. The school is a few blocks away, but there's an annoying hil.\n\z
			There's probably no traffic so I should be ok..."
	
	think   [[I turn around a few corridors and up ahead is the last turn.]]
	
	freja   [[I'M ALMOST THERE!!]]
	
	think   [[My sneakers squeak as I turn and then---]]
	
	scene.bg ""
	freja:hide()
	think   [[I black out a bit and my head hurts.]]
	
	mathilde    [["Oh jeez..."]]
	freja:show()
    mathilde:show()
    mathilde:move(2) -- She's to the right of us
	scene.bg "bgs/school_day"

	think   [[I open my eyes and see a familiar red figure on the ground - an older version of the girl I saw in my dream,  Mathilde.]]
	think   [[She's rubbing her head and my bread is stuck on her shirt.]]
	
	freja   [["S-Sorry, Mathilde!!"]]
	
	freja   [[I quickly get up and hold out my hand. She looks up and laughs before taking it.]]
	
	mathilde [["Pfft, I didn't expect to see you this late!"]]
	
	freja   [["Eheh...well I overslept."]]
	
	mathilde [["Actually...same here. I had a weird dream..."]]
	
	freja   [[She then stares blankly at me and covers her mouth in shock.]]
	
	mathilde [["Your nose is bleeding!! You need to go to the nurse's office!!"]]
	
	freja   [[Mathilde grabs my hand firmly and drags me to school. I try my best to cover my nose but the blood keeps flowing out.]]

    -- transition to corridor
    scene.bg "bgs/corridor"
	freja "By the time we arrived at the nurse's office, the first period class ended and the students are moving to their next classrooms.\n\z
			It was quite crowded, but Mathilde keeps me close to her."
	freja [[She's really kind when she wants to be - other times...she's a bit more aloof.]]
	
	--scene change to nurse's office
	scene.bg "bgs/lab" -- TODO: Find a better background
	freja [[We finally arrive at the nurse's office and the nurse opens the door.]]
	
	nurse [["Oh hello, Mathilde! Who's this behind you?"]]
	
	mathilde "Ah, this is Freja. I accidentally bumped into her and her nose is bleeding..."
	mathilde [[She quickly passes the nurse, grabs some tissues, and hands them to me.]]
	
	nurse [["Oh dear, well she can rest here!"]]
	
	mathilde [["Great!"]]
	
	freja [[Mathilde turns to me and says...]]
	
	mathilde [["Just rest here and I'll come back to see you, ok?"]]
	
	local result = choice(
        "What should I say?", {
            "\"Alright, I'll see you later...and thanks, Mathilde.\"", 
            "\"Ah, you don't have to! But thank you anyways!\""
    })
	if result == 1 then
		scene.change "chapter2_mathilde"
	elseif result == 2 then
		-- scene.change ""
		think "TODO: Implement this route"
		exit()
	end
end
	
::LessSleep::
do
    freja 	[["Well... I like to see the sunrise. It'd be nice."]]

	scene.bg "bgs/bedroom"
	think 	"I throw my blanket off, jump out of bed and head to the restroom.\n\z
			My hair is a bit of a mess but managable - a quick shower\n\z
			should help."
	
	think	"I go ahead and takea quick shower - daydreaming a bit."
	think	"§pNow that I think about it, Karla would be up this early too.\n\z
			She's a cool friend of mine and is always on top of her game."
	think	"She recently got in to a renowned university, while me§p.§p.§p.§p?\n\z
			I'm just going to community college. I still wonder to this day:\n\z
			why are we still friends?"

	think 	"I turn off the shower head, dry up, put on some clothes & my\n\z
			favourite leather jacket and head downstairs."

	scene.bg "bgs/livingroom"
	think	"Ma is already making breakfast - it smells like bacon-wrapped\n\z
			turkey sausages."

	freja	[["G'morning, Ma."]]
	mom		"\"Ah! You're up early for once! Good morning, Freja.\n\z
			How's my little sunflower?\""
	freja	[["I'm doing alright."]]
	mom		[["Oh? Did you get a date yet for the Gala?"]]

	think	"I groan§p§p - §wright§w§p§p§p, that event is comming up.\n\z
			It's a special coming of age ceremony that initiates\n\z
			us into adulthood. Don't care much for it myself."
	freja	"...No."

	mom		[["Well, you better soon! It's the best time to find a life partner!"]]
	think	"My mother and many of the elders in the town believe that your\n\z
			Gala partner is your fated one for life...\n\z
			I just think it's unnecessary. Karla would think so too."
	think 	"She would say that careers are more important than love."

	think	"I take a fork and stab a couple of bacon-wrapped sausages."
	mom		[["You don't need to kill the sausages, dear."]]
	think	"I bite them off the fork and roll my eyes."
	freja	[["Well, they're already dead."]]
	mom		[["Freja, you know what I mean..."]]

	think 	"I finish the rest of my breakfast and puck up my bag."
	freja	[["...I know. See you later, okay? Thanks, Ma."]]
	think	"Ma smiles sweetly and waves as I exit the house."

	scene.bg "bgs/park_day"
	think	"The school is only a few blocks away and with a hill in the way.\n\z
			But occasionally I like to take the scenic route through the park."
	
	-- TODO: transscribe the wall of text

	think "But now that I think about it,§p§p§p why did she make a sunflower?"
	think "My ears twitch - I hear footsteps approaching and I turn around-"

	freja:move(0)
	karla:show()
	karla:move(2)
	think "I see a blue-haired cat, speak of the devil. It's Karla."

	think "TODO: Implement this route"
	exit()
end