function bootstrap()
    freja = define("Freja", {
        neutral="char/freja_neutral",
        happy="char/freja_happy",
        angry="char/freja_angry",
        sad="char/freja_sad",
        shocked="char/freja_shocked"
    })
    mathilde = define("Mathilde", {
		neutral="char/mathilde_neutral",
		happy="char/mathilde_happy",
		angry="char/mathilde_angry",
		sad="char/mathilde_sad",
		disgust="char/mathilde_disgust",
		angry_disgust="char/mathilde_angry_disgust",
		disappointed="char/mathilde_disappointed"
	})
    karla = define("Karla", {neutral="char/karla_neutral"})
    mom = define("Mom", {})
    nurse = define("School Nurse", {})
    cprez = define("Class Prez", {})

	set_title("Behind Masked Hearts")
    start_scene("intro")
end