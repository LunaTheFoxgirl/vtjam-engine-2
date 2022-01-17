::chapter2_karla::
do
	scene.bg "bgs/school_afternoon"
	mathilde:hide()
	freja:show()
	freja:move(2)
	karla:show()
	karla:move(0)
	
	cprez 	"\"... And then he apparently was with both of them!\""
	
	think 	"The lunch table stares in shock and Karla rolls her eyes. \n\z
			I put my tray next to her and she turns over to me \n\z
			with a smile."
			
	karla	"\"Oh hey, Freja! The President is about to tell another story.\""
	
	think 	"She leans in close to my ear and whispers."
	
	karla	"\"Want to dip?\""
	
	local result = choice(
        "Do you dip?", {
            "Heck yeah.",
            "Nah, I want to hear what's up."
    }) 
	if result == 1 then
		goto scene_1
	elseif result == 2 then
		goto scene_2
 	end
	
::scene_1::
	think 	"I nod as I eat my lunch and in response \n\z
			she grins."
			
	freja	"\"Just let me eat first.\""
	
	karla	"\"Sounds good.\""
	
	think	"As I eat, I pretend to listen to the President \n\z
			But really I'm looking at Karla."
			
	think	"There's a lot between us and I think of us as friends \n\z
			but I genuinely feel like I'm going to miss her a lot \n\z
			after graduation."
			
	think	"...Although, why does she want to hang out alone with me \n\z
			for lunch?"
			
	think	"I quickly eat my food and then tap Karla's shoulder. \n\z
			She turns and nods."
			
	think	"We both get up and I followed her to the school."
	
	scene.bg "bgs/corridor"
	
	freja	"\"So...what did you want to talk about?"
	
	karla	"\"...Do you remember that sunflower statue from 3rd grade?\""
	
	freja	"\"Yeah? What about it?\""
	
	karla	"\"W-Well...I've been meaning to tell you that I made it for you.\""
	
	freja	"\"I stare at her blankly. So...was that why she was confused back then?\""
	
	freja	"\"Wait, like...as a friend or...?\""
	
	freja:expr "shocked"
	
	think	"Karla looks away for a second and sighs."
	
	karla	"\"M-Must I be so obvious to you?\""
	
	think	"She steps forward and leans close to my ear."
	
	karla	"\"Will you go to the Gala with me?\""
	
	karla:hide()
	freja:hide()
	
	scene.bg""
	
	think	"To Be Continued..."
	
	scene.change	"conclusion"
	
	--by the end of the scene, karla gives freja note to meet at the sunflower statue.

::scene_2::
	freja	"\"Nah, I want to hear what's up.\""
	
	karla	"\"Oh? I thought this wasn't your thing.\""
	
	freja	"\"You're the one who taught me to be social - remember?\""
	
	karla	"\"Ah, that's right...you learn well.\""
	
	think 	"For the rest of lunch, I listened to the President's story \n\z
			but when I went to put my tray away, I found a note."
			
	think	"It's a note from Karla: \"Meet me at the Sunflower Statue after school.\""
	
	--by the end of the scene, karla gives freja a note to meet at the sunflower statue.
	
	karla:hide()
	freja:hide()
	
	scene.bg""
	
	think	"To Be Continued..."
	
	scene.change	"conclusion"

end