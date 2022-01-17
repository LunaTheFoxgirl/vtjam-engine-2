::chapter2_introduction::
do
	scene.bg "bgs/school_afternoon"
	
	think 	"After an eventful first period, it's finally lunch time. \n\z
			The cafeteria line is a bit full, but I always get the best bits \n\z
			thanks to my favorite lunch lady."
			
	think	"Today I got a peanut butter sandwich, banana, angry water \n\z
			(sparkling water), and some candy."
	
	think 	"I carry my tray out the cafeteria and look around for a seat. \n\z
			The only available spots seem to be the tree near the class \n\z
			trailers and the student council lunch tables."
			
	think	"Mathilde seems to be making a flower crown at \n\z
			the tree and Karla seems to be listening to the \n\z
			Student Council President's gossip."
			
	local result = choice(
        "Who should I eat with for lunch?", {
            "Eat with Karla.",
            "Eat with Mathilde."
    }) 
	if result == 1 then
		scene.change "chapter2_karla"
	elseif result == 2 then
		scene.change "chapter2_mathilde"
 	end
end