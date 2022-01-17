::chapter2_mathilde::
do
	scene.bg "bgs/school_afternoon"
	freja:show()
	freja:move(2)
	mathilde:show()
	mathilde:move(0)
	
	think 		"I walk over to the tree."

	-- scene change to back of school

	mathilde 	"\"Oho? So you did want to see me afterall.\""

	freja 		"\"Yeah, I wanted to thank you properly.\""
	think 		"I sit down and place my tray on my lap."

	mathilde 	"\"It's no biggie! I'm just glad that you're doing better.\""

	think 		"She puts her flower crown to the side and opens up her bag. \n\z
				She pulls out a black lunchbox and opens it."

	think	 	"In it, there's a small bag with spider web patterns, a sandwich, \n\z
				and an apple juice box. She picks up the bag and shows it to me."

	mathilde	"\"By the way, I made some cookies - wanna try them?\""

	local result = choice("Try the cookies?", {"Yes, please!", "No, I'm ok"})
	if result == 1 then
		goto accept_cookies
	elseif result == 2 then
		goto deny_cookies
	end
	
end


::accept_cookies::
do
	freja:expr "happy"
	freja 		"\"Yes, please!\""

	think 		"I attempt to grab a piece from the bag, but \n\z
				she grabs my hand instead and feeds me a cookie."

	think 		"My face turns warm as I eat the cookie. The sugars melt in my mouth and \n\z
				I swore it melted faster due to my face turning red."

	mathilde 	"\"How is it?\""

	freja 		"\"Uhhh, it's pretty good! Can I have another?\""

	mathilde:expr "happy"
	think 		"She grins with her little fangs peeking out."

	mathilde 	"\"Hehe! You're the first one to say that and sure!\""

	think 		"She hands me a cookie and I stare at it."
	
	freja:expr "sad"
	freja 		"\"...I'm the first one? Has anyone else tried them?\""

	think 		"Mathilde puts a cookie in her mouth and looks down. She shakes her head."
	mathilde:expr "sad"
	
	freja 		"\"Well, what about your mom or dad?\""

	mathilde:expr "angry"
	
	mathilde 	"\"What about them?\""

	freja:expr "shocked"
	think 		"I shut my mouth. I've never seen Mathilde glare like this."

	mathilde 	"\"Oh shit!\""

	think 		"or even curse for that matter."

	mathilde:expr "sad"
	mathilde 	"\"I-I'm sorry!\""

	think 		"She suddenly gets up and runs off to the other side of the field."

	mathilde:hide()
	think 		"Should I run after her? I don't know if I should. I've never seen her like this before."

	think 		"It's a bit frightening to think that there's this side of her, but... \n\z
				I need to know she's ok."

	--school bell rings

	freja:expr "sad"
	think 		"but...lunch is over...I should talk to her tonight if I can."

	think 		"I quickly pack up my lunch and look back one more time to see if she's nearby. \n\z
				In the bushes, a hint of red fur pops out and I tiptoe towards it."

	freja:expr "neutral"
	freja 		"\"If...you don't mind. I'll call you tonight, ok?\""

	think		"The red fur stiffens up and then relaxes down into the bush. I guess that's a yes."

	think 		"I walk back to the school to the last set of classes for the day."
	
	mathilde:hide()
	freja:hide()
	
	scene.bg""
	
	think	"To Be Continued..."
	
	scene.change	"conclusion"
end

::deny_cookies::
do 
	freya 		"\"I'm alright. My stomach feels off from this morning.\""

	think 		"I probably didn't eat enough now that I think about it..."

	mathilde 	"\"Oh no! Here -- try my tea! It should help.\""

	think 		"She hands me a canister of tea. It smells of honey and lemon. \n\z 
				I hold it gently in the palm of my hand."

	freja:expr "happy" 
	
	freja		"\"Oh! Thanks!\""

	mathilde 	"\"Yeah, no problem!\""

	think 		"I take a careful sip of tea. It warms my throat. It's like a nice hug."

	freja 		"\"You're really good at this home cooking stuff, huh?\""

	mathilde 	"\"Heh, yeah -- it's a little hobby. Although I have to cook most of my food myself.\""

	freja 		"\"Really? What about your mom though?\""

	think 		"Her body stiffens before replying."

	mathilde:expr "angry"
	
	mathilde 	"\"What about her?\""

	freja 		"\"Er...what about your dad.\""

	mathilde:expr "disgust"
	mathilde 	"\"...\""

	think 		"Her face has a deep set glare. \n\z
				This is a topic she clearly doesn't want to talk about."

	freja:expr "sad"
	freja 		"\"Sorry, Mathilde.\""

	think 		"She takes a deep breath in and lets it out."

	mathilde:expr "neutral"
	mathilde 	"\"It's alright...It's just an uncomfortable topic for me. We tend to have disagreements and...\""

	think 		"She rubs her left arm and looks down."

	mathilde:expr "sad"
	mathilde 	"\"It can be a lot.\""
	
	think 		"I stare at her. Does she get hurt at home...?"

	freja:expr "neutral"
	freja 		"\"Mathilde, if...if you need anyone to talk to...I'm here for you, ya know?\""

	think 		"She nods and looks up at me with a smile."

	mathilde:expr "happy"
	mathilde 	"\"Thanks, Freja.\""
	
	mathilde:hide()
	freja:hide()
	
	scene.bg ""
	
	think	"To Be Continued..."
	
	scene.change	"conclusion"

end