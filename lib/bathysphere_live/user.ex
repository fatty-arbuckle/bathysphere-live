defmodule BathysphereLive.User do

  @adjectives ~w(
    Defiant Homeless Adorable Delightful Homely Quaint Adventurous Depressed Horrible
    Aggressive Determined Hungry Real Agreeable Different Hurt Relieved Alert Difficult
    Repulsive Alive Disgusted Ill Rich Amused Distinct Important Angry Disturbed Impossible
    Scary Annoyed Dizzy Inexpensive Selfish Annoying Doubtful Innocent Shiny Anxious
    Drab Inquisitive Shy Arrogant Dull Itchy Silly Ashamed Sleepy Attractive Eager Jealous
    Smiling Average Easy Jittery Smoggy Awful Elated Jolly Sore Elegant Joyous Sparkling
    Bad Embarrassed Splendid Beautiful Enchanting Kind Spotless Better Encouraging Stormy
    Bewildered Energetic Lazy Strange Black Enthusiastic Light Stupid Bloody Envious
    Lively Successful Blue Evil Lonely Super Excited Long Blushing Expensive Lovely
    Talented Bored Exuberant Lucky Tame Brainy Tender Brave Fair Magnificent Tense Breakable
    Faithful Misty Terrible Bright Famous Modern Tasty Busy Fancy Motionless Thankful
    Fantastic Muddy Thoughtful Calm Fierce Mushy Thoughtless Careful Filthy Mysterious
    Tired Cautious Fine Tough Charming Foolish Nasty Troubled Cheerful Fragile Naughty
    Clean Frail Nervous Ugliest Clear Frantic Nice Ugly Clever Friendly Nutty Uninterested
    Cloudy Frightened Unsightly Clumsy Funny Obedient Unusual Colorful Obnoxious Upset
    Combative Gentle Odd Uptight Comfortable Gifted Concerned Glamorous Open Vast Condemned
    Gleaming Outrageous Victorious Confused Glorious Outstanding Vivacious Cooperative Good
    Courageous Gorgeous Panicky Wandering Crazy Graceful Perfect Weary Creepy Grieving
    Plain Wicked Crowded Grotesque Pleasant Cruel Grumpy Poised Wild Curious Poor Witty
    Cute Handsome Powerful Worrisome Happy Precious Worried Dangerous Healthy Prickly Wrong
    Dark Helpful Proud Dead Helpless Putrid Zany Defeated Hilarious Puzzled Zealous
  )

  @nouns ~w(
    Actor Gold Painting Advertisement Grass Parrot Afternoon Greece Pencil Airport Guitar Piano
    Ambulance Hair Pillow Animal Hamburger Pizza Answer Helicopter Planet Apple Helmet Plastic
    Army Holiday Portugal Australia Honey Potato Balloon Horse Queen Banana Hospital Quill
    Battery House Rain Beach Hydrogen Rainbow Beard Ice Raincoat Bed Insect Refrigerator
    Belgium Insurance Restaurant Boy Iron River Branch Island Rocket Breakfast Jackal Room
    Brother Jelly Rose Camera Jewellery Russia Candle Jordan Sandwich Car Juice School
    Caravan Kangaroo Scooter Carpet King Shampoo Cartoon Kitchen Shoe China Kite Soccer
    Church Knife Spoon Crayon Lamp Stone Crowd Lawyer Sugar Daughter Leather Sweden
    Death Library Teacher Denmark Lighter Telephone Diamond Lion Television Dinner Lizard Tent
    Disease Lock Thailand Doctor London Tomato Dog Lunch Toothbrush Dream Machine Traffic
    Dress Magazine Train Magician Truck Egg Manchester Uganda Eggplant Market Umbrella
    Egypt Match Van Elephant Microphone Vase Energy Monkey Vegetable Engine Morning Vulture
    England Motorcycle Wall Evening Nail Whale Eye Napkin Window Family Needle Wire
    Finland Nest Xylophone Fish Nigeria Yacht Flag Night Yak Flower Notebook Zebra
    Football Ocean Zoo Forest Oil Garden Fountain Orange Gas France Oxygen Girl
    Furniture Oyster Glass Garage Ghost
  )

  def random do
    Enum.random(@adjectives) <> " " <> Enum.random(@nouns)
  end

end
