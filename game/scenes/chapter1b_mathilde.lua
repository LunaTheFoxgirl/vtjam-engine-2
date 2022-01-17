::chapter1b_mathilde::
do
	scene.bg "bgs/lab"
	freja:show()
	freja:move(0)
	mathilde:show()
    mathilde:move(2)
	
	think	"She blinks and her face flushes."
	
	mathilde:expr "happy"
	
	mathilde "\"I would if I could but...I have class. I'm late too.\""
	
	freja	"\"Oh, right-- but...can I ask you one thing before you go?\""
	
	mathilde	"\"Uh sure?\""
	
	freja	"\"Why were you late?\""
	
	think	"Mathilde takes a step back and nervously laughs. \n\z
			Her tail slinks away from me."
			
	mathilde:expr "sad"
	
	mathilde	"\"It was just a small thing. I had to do an errand.\""
	
	think	"An errand in the morning? That doesn't really sound like her."
	
	freja	"\"...really?\""
	
	mathilde	"\"Y-Yes, really!\""
	
	mathilde:expr "happy"
	
	think	"I get up and approach her. She shrinks back against a wall..."
	
	think	"and I push her against it. It's a good thing that I'm taller than her. \n\z
			Her face flushes deeply as she looks up at me."
	
	think	"Then, she looks away begrudgingly."

	mathilde	"\"Fine, I'll tell you..."
	
	mathilde	"\"LATER!!!!\""
	
	
	freja:expr "shocked"
	
	think	"And with a simple push -- she slips under me and runs off. \n\z
			I look outside the nurse's office."
	
	freja:expr "angry"
	
	think	"She sticks her tongue at me and blends with the crowd. \n\z
			I probably teased her too much, haha."
			
	freja:expr	"neutral"
	mathilde:hide()
	
	think	"Then, the bell rings. It's lunchtime. I'll probably see \n\z
			Mathilde at her favorite spot." 
	
	scene.change"chapter2_introduction"
			
	--goes to chapter2_introduction
end