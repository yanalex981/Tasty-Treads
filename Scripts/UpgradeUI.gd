extends Control

# ---------- TOGGLE BUTTON VARIABLES ---------- #
@onready var whiskToggle = $"CenterAlign/Buttons/WhiskButtons/WhiskToggle"
@onready var cutterToggle = $"CenterAlign/Buttons/CookieCutterButtons/CookieCutterToggle"
@onready var ovenToggle = $"CenterAlign/Buttons/OvenButtons/OvenToggle"
@onready var tuneUpToggle = $"CenterAlign/Buttons/TuneUpButtons/TuneUpToggle"
@onready var droid1Toggle = $"CenterAlign/Buttons/Droid1Buttons/Droid1Toggle"
@onready var droid2Toggle = $"CenterAlign/Buttons/Droid2Buttons/Droid2Toggle"
# ---------- PURCHASE BUTTON VARIABLES ---------- #
@onready var whiskPurchaseButton = $"CenterAlign/Buttons/WhiskButtons/WhiskPurchase"
@onready var cutterPurchaseButton = $"CenterAlign/Buttons/CookieCutterButtons/CookieCutterPurchase"
@onready var ovenPurchaseButton = $"CenterAlign/Buttons/OvenButtons/OvenPurchase"
@onready var tuneUpPurchaseButton = $"CenterAlign/Buttons/TuneUpButtons/TuneUpPurchase"
@onready var droid1PurchaseButton = $"CenterAlign/Buttons/Droid1Buttons/Droid1Purchase"
@onready var droid2PurchaseButton = $"CenterAlign/Buttons/Droid2Buttons/Droid2Purchase"
# ---------- PURCHASE BUTTON LABELS ---------- #
@onready var whiskLabel = $"CenterAlign/Buttons/WhiskButtons//WhiskLabel"
@onready var cutterLabel = $"CenterAlign/Buttons/CookieCutterButtons/CookieCutterLabel"
@onready var ovenLabel = $"CenterAlign/Buttons/OvenButtons/OvenLabel"
@onready var tuneUpLabel = $"CenterAlign/Buttons/TuneUpButtons/TuneUpLabel"
@onready var droid1Label = $"CenterAlign/Buttons/Droid1Buttons/Droid1Label"
@onready var droid2Label = $"CenterAlign/Buttons/Droid2Buttons/Droid2Label"
# ---------- OTHER UI VARIABLES ---------- #
@onready var purchaseConfirmPanel = $"PurchaseConfirmPanel"
@onready var earningsLabel = $"earnings_label"

const WHISK_PRICE = 50
const CUTTER_PRICE = 50
const OVEN_PRICE = 50
const TUNE_UP_PRICE = 100
const DROID_1_PRICE = 150
const DROID_2_PRICE = 150
const PURCHASE_CONFIRM_ALPHA = 1
const FADE_SPEED = 0.75

var money = 250
var justPurchased = false
var insufficientFunds = false
var whiskActivated = false
var cutterActivated = false
var ovenActivated = false
var tuneUpActivated = false
var droid1Activated = false
var droid2Activated = false

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set the label text using the specified constant variables
	whiskLabel.text = "Electric Whisk ($%.0f) -- Because hand mixing is for chumps." % WHISK_PRICE
	cutterLabel.text = "Dual-Wield Cookie Cutters ($%.0f) -- You... do realize you have two hands, right?" % CUTTER_PRICE
	ovenLabel.text = "Oven-O'-Matic 5090Ti ($%.0f) -- Cook faster! Cook easier! Cook with fancy lighting settings!" % OVEN_PRICE
	tuneUpLabel.text = "Tune Up ($%.0f) -- When was the last time you got your gears checked? You're rollin' a little slow." % TUNE_UP_PRICE
	droid1Label.text = "Chef Droid 1 ($%.0f) -- Why do all the work when you could pay someone pennies on the dollar instead!" % DROID_1_PRICE
	droid2Label.text = "Chef Droid 2 ($%.0f) -- The Sequel. It's the same concept but you're still gonna pay to see it." % DROID_2_PRICE
	# Link the purchase functions with their respective buttons
	whiskPurchaseButton.pressed.connect(_purchaseWhisk)
	cutterPurchaseButton.pressed.connect(_purchaseCutter)
	ovenPurchaseButton.pressed.connect(_purchaseOven)
	tuneUpPurchaseButton.pressed.connect(_purchaseTuneUp)
	droid1PurchaseButton.pressed.connect(_purchaseDroid1)
	droid2PurchaseButton.pressed.connect(_purchaseDroid2)
	# Set all toggles to invisible by default
	whiskToggle.visible = false
	cutterToggle.visible = false
	ovenToggle.visible = false
	tuneUpToggle.visible = false
	droid1Toggle.visible = false
	droid2Toggle.visible = false
	# Set the alpha value of the confirmation panel
	purchaseConfirmPanel.modulate.a = PURCHASE_CONFIRM_ALPHA
	# Make whisk purchase button selected by default
	whiskPurchaseButton.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	earningsLabel.text = "Earnings: $%0.2f" % money
	
	# ---------- Code for pop-up after successful purchase ---------- #
	if justPurchased:
		purchaseConfirmPanel.visible = true
		purchaseConfirmPanel.modulate.a = PURCHASE_CONFIRM_ALPHA
		justPurchased = false
	elif purchaseConfirmPanel.visible and purchaseConfirmPanel.modulate.a > 0:
		purchaseConfirmPanel.modulate.a -= FADE_SPEED * delta
	elif purchaseConfirmPanel.visible and purchaseConfirmPanel.modulate.a <= 0:
		purchaseConfirmPanel.visible = false
	
	# ---------- Code for making earnings flash red if player has insufficient funds for purchase ---------- #
	if insufficientFunds:
		earningsLabel.modulate.g = 0
		earningsLabel.modulate.b = 0
		insufficientFunds = false
	elif earningsLabel.modulate.g < 1 or earningsLabel.modulate.b < 1:
		earningsLabel.modulate.g += FADE_SPEED * delta
		earningsLabel.modulate.b += FADE_SPEED * delta
	
	# ---------- Changing powerup variables and labels for purchased powerups ---------- #
	if !whiskToggle.disabled:
		if whiskToggle.button_pressed:
			whiskActivated = true
			whiskLabel.text = "Electric Whisk active"
		else:
			whiskActivated = false
			whiskLabel.text = "Electric Whisk inactive"
	
	if !cutterToggle.disabled:
		if cutterToggle.button_pressed:
			cutterActivated = true
			cutterLabel.text = "Dual-Wield Cookie Cutters active"
		else:
			cutterActivated = false
			cutterLabel.text = "Dual-Wield Cookie Cutters inactive"
	
	if !ovenToggle.disabled:
		if ovenToggle.button_pressed:
			ovenActivated = true
			ovenLabel.text = "Oven-O'-Matic 5090Ti active"
		else:
			ovenActivated = false
			ovenLabel.text = "Oven-O'-Matic 5090Ti inactive"
	
	if !tuneUpToggle.disabled:
		if tuneUpToggle.button_pressed:
			tuneUpActivated = true
			tuneUpLabel.text = "Tune Up active"
		else:
			tuneUpActivated = false
			tuneUpLabel.text = "Tune Up inactive"
	
	if !droid1Toggle.disabled:
		if droid1Toggle.button_pressed:
			droid1Activated = true
			droid1Label.text = "Chef Droid 1 active"
		else:
			droid1Activated = false
			droid1Label.text = "Chef Droid 1 inactive"
	
	if !droid2Toggle.disabled:
		if droid2Toggle.button_pressed:
			droid2Activated = true
			droid2Label.text = "Chef Droid 2 active"
		else:
			droid2Activated = false
			droid2Label.text = "Chef Droid 2 inactive"

func _purchaseWhisk():
	if money >= WHISK_PRICE:
		money -= WHISK_PRICE
		whiskActivated = true
		justPurchased = true
		# Hide the purchase button
		whiskPurchaseButton.disabled = true
		whiskPurchaseButton.visible = false
		#Reveal the toggle button
		whiskToggle.disabled = false
		whiskToggle.visible = true
		whiskToggle.button_pressed = true
		# Change focus to the toggle that just activated
		whiskToggle.grab_focus()
	else:
		insufficientFunds = true

func _purchaseCutter():
	if money >= CUTTER_PRICE:
		money -= CUTTER_PRICE
		cutterActivated = true
		justPurchased = true
		# Hide the purchase button
		cutterPurchaseButton.disabled = true
		cutterPurchaseButton.visible = false
		#Reveal the toggle button
		cutterToggle.disabled = false
		cutterToggle.visible = true
		cutterToggle.button_pressed = true
		# Change focus to the toggle that just activated
		cutterToggle.grab_focus()
	else:
		insufficientFunds = true

func _purchaseOven():
	if money >= OVEN_PRICE:
		money -= OVEN_PRICE
		ovenActivated = true
		justPurchased = true
		# Hide the purchase button
		ovenPurchaseButton.disabled = true
		ovenPurchaseButton.visible = false
		#Reveal the toggle button
		ovenToggle.disabled = false
		ovenToggle.visible = true
		ovenToggle.button_pressed = true
		# Change focus to the toggle that just activated
		ovenToggle.grab_focus()
	else:
		insufficientFunds = true

func _purchaseTuneUp():
	if money >= TUNE_UP_PRICE:
		money -= TUNE_UP_PRICE
		tuneUpActivated = true
		justPurchased = true
		# Hide the purchase button
		tuneUpPurchaseButton.disabled = true
		tuneUpPurchaseButton.visible = false
		#Reveal the toggle button
		tuneUpToggle.disabled = false
		tuneUpToggle.visible = true
		tuneUpToggle.button_pressed = true
		# Change focus to the toggle that just activated
		tuneUpToggle.grab_focus()
	else:
		insufficientFunds = true

func _purchaseDroid1():
	if money >= DROID_1_PRICE:
		money -= DROID_1_PRICE
		droid1Activated = true
		justPurchased = true
		# Hide the purchase button
		droid1PurchaseButton.disabled = true
		droid1PurchaseButton.visible = false
		#Reveal the toggle button
		droid1Toggle.disabled = false
		droid1Toggle.visible = true
		droid1Toggle.button_pressed = true
		# Change focus to the toggle that just activated
		droid1Toggle.grab_focus()
	else:
		insufficientFunds = true

func _purchaseDroid2():
	if money >= DROID_2_PRICE:
		money -= DROID_2_PRICE
		droid2Activated = true
		justPurchased = true
		# Hide the purchase button
		droid2PurchaseButton.disabled = true
		droid2PurchaseButton.visible = false
		#Reveal the toggle button
		droid2Toggle.disabled = false
		droid2Toggle.visible = true
		droid2Toggle.button_pressed = true
		# Change focus to the toggle that just activated
		droid2Toggle.grab_focus()
	else:
		insufficientFunds = true
