::Introduction::
    -- Starts with a black screen and slowly transitions to Bedroom.Dawn
    scene.bg ""

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
    scene.bg "bgs/bedroom"
	-- Starts with Alarm SFX
	
	freja:show()
	
	freja [["MMm... I hate alarms.”]]
	think [[I open one eye and peer at the clock. It’s 5 am.]]
	
	local result = choice(
        "Should I get more shut eye...? It's just Monday.", {
            "Yes, sleep some more.",
            "No, get up early."
    })
	if result == 1 then
		goto MoreSleep
	elseif result == 2 then
		goto LessSleep
    end
end
		  
::MoreSleep::
do
	freja   [["Mmm....too early."]]
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
	
	freja:expr "shocked"
	think   "I wake up from my bed in a cold sweat and turn to the clock. It’s 7 am.§p\n\z
            Shit.§p§p I quickly change clothes and run downstairs."
    
    -- Mom is talking
    freja:expr "neutral"
	mom     [["Freja! You're going to be late again!"]]
	
	freja   [["I know! I know!!"]]
	freja   [[I take a piece of bread from the kitch counter and put it in my mouth.]]
	
	mom     [["Make sure to get a big lunch, sunflower! Oh and find a date for the Gala!!"]]
	
	think   [[The What??]]
	
	freja   [["Uh, sure, Ma! Cya later"]]
	
	freja   "I slip on my sneakers and run off. The school is a few blocks away, but there's an annoying hil.\n\z
			There's probably no traffic so I should be ok..."
	
	freja   [[I turn around a few corridors and up ahead is the last turn.]]
	
	freja   [[ I'M ALMOST THERE!!]]
	
	freja   [[My sneakers squeak as I turn and then---]]
	
	think   [[I black out a bit and my head hurts.]]
	
	mathilde    [["Oh jeez..."]]
    mathilde:show()
    mathilde:move(2) -- She's to the right of us

	freja   [[I open my eyes and see a familiar red figure on the ground - an older version of the girl I saw in my dream,  Mathilde.]]
	freja   [[She's rubbing her head and my bread is stuck on her shirt.]]
	
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
		scene.change "(Chapter 2.Mathilde)"
	elseif result == 2 then
		scene.change ""
    end
end
	
::LessSleep::
do
    freja "I should really get up"
end