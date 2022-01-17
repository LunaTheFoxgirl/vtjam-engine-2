::chapter1a_mathilde::
do
	scene.bg "bgs/lab"
	freja:show()
	freja:move(0)
	mathilde:hide()
	
	think	"Mathilde leaves the nurse's office quickly. \n\z
			She must be busy. I look at the clock - it's \n\z
			around 11 am."
			
	think	"But, something drops from her pocket - a small yellow flower petal. \n\z
			It looks like a sunflower petal."
			
	think	"Huh? Why does she have a sunflower petal? Not many grow here."
	
	nurse	"\"Freja, can you rest here on the bed?\""
	
	freja	"\"Ah, sure.\""
	
	think	"I move to the bed near the window and make myself comfortable."
	
	think	"It's really a nice day out. The sun is bright and warms my ears."
	
	think	"I'm really glad that Mathilde was there to help me out. \n\z
			She always tries to help others. I remember when we first met..."
			
	think	"She was a shy little transfer fox student. I helped guide her \n\z
			as homeroom representative and now she really blossomed."
			
	think	"She's honestly an inspiration to me...I hope we can continue being \n\z
			good friends."
			
	think	"or...something more?"
	
	--pause
	
	think	"No, no - she probably doesn't think that way. \n\z
			I'm sure she already has someone in mind."
			
	think	"But, who would that be...? \n\z
			I haven't really noticed her hanging out \n\z
			with someone specific."
			
	think	"She tends to be friendly with everyone."
	
	nurse	"\"Freja, how are you feeling?\""
	
	think	"I look down at my nose and pull out the tissues. The blood darkened up."
	
	freja	"\"I think I got better! Thanks Nurse!"
	
	nurse	"\"It's no problem! Since you're feeling better, you should be fine for lunch period. \n\z
			You should go thank your friend for helping you out!"
			
	think	"I get off the bed and get my bag."
	
	freja	"\"Alright! Cya later!\""
	
	think	"I exit the nurse's office and walk down the hallway. \n\z
			It should be lunch time soon--"
	
	think	"Then the bell rings. It's lunchtime. Outside the hallway, \n\z
			students quickly move out to the lunchline. \n\z
			In the corner of my eye, I see Mathilde rest comfortably under a tree \n\z
			and other familiar faces."
			
	scene.change "chapter2_introduction"		
	-- go to chapter2_introduction
end