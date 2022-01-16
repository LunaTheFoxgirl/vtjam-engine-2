function bootstrap()
    freja = define("Freja", {
        neutral="char/freja_neutral",
        happy="char/freja_happy",
        angry="char/freja_angry",
        sad="char/freja_sad",
        shocked="char/freja_shocked"
    })
    mathilde = define("Mathilde", {neutral="char/mathilde_neutral"})
    karla = define("Karla", {neutral="char/karla_neutral"})
    mom = define("Mom", {})

    start_scene("scene0")
end