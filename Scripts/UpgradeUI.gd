class_name UpgradeUI
extends CanvasLayer

signal upgrading_finished

# ---------- TOGGLE BUTTON VARIABLES ---------- #
@onready var whiskToggle = $UpgradeUI/CenterAlign/Buttons/WhiskButtons/WhiskToggle
@onready var cutterToggle = $"UpgradeUI/CenterAlign/Buttons/CookieCutterButtons/CookieCutterToggle"
@onready var ovenToggle = $"UpgradeUI/CenterAlign/Buttons/OvenButtons/OvenToggle"
@onready var tuneUpToggle = $"UpgradeUI/CenterAlign/Buttons/TuneUpButtons/TuneUpToggle"
@onready var droid1Toggle = $"UpgradeUI/CenterAlign/Buttons/Droid1Buttons/Droid1Toggle"
@onready var droid2Toggle = $"UpgradeUI/CenterAlign/Buttons/Droid2Buttons/Droid2Toggle"
# ---------- PURCHASE BUTTON VARIABLES ---------- #
@onready var whiskPurchaseButton = $"UpgradeUI/CenterAlign/Buttons/WhiskButtons/WhiskPurchase"
@onready var cutterPurchaseButton = $"UpgradeUI/CenterAlign/Buttons/CookieCutterButtons/CookieCutterPurchase"
@onready var ovenPurchaseButton = $"UpgradeUI/CenterAlign/Buttons/OvenButtons/OvenPurchase"
@onready var tuneUpPurchaseButton = $"UpgradeUI/CenterAlign/Buttons/TuneUpButtons/TuneUpPurchase"
@onready var droid1PurchaseButton = $"UpgradeUI/CenterAlign/Buttons/Droid1Buttons/Droid1Purchase"
@onready var droid2PurchaseButton = $"UpgradeUI/CenterAlign/Buttons/Droid2Buttons/Droid2Purchase"
# ---------- PURCHASE BUTTON LABELS ---------- #
@onready var whiskLabel = $"UpgradeUI/CenterAlign/Buttons/WhiskButtons//WhiskLabel"
@onready var cutterLabel = $"UpgradeUI/CenterAlign/Buttons/CookieCutterButtons/CookieCutterLabel"
@onready var ovenLabel = $"UpgradeUI/CenterAlign/Buttons/OvenButtons/OvenLabel"
@onready var tuneUpLabel = $"UpgradeUI/CenterAlign/Buttons/TuneUpButtons/TuneUpLabel"
@onready var droid1Label = $"UpgradeUI/CenterAlign/Buttons/Droid1Buttons/Droid1Label"
@onready var droid2Label = $"UpgradeUI/CenterAlign/Buttons/Droid2Buttons/Droid2Label"
# ---------- OTHER UI VARIABLES ---------- #
@onready var purchaseConfirmPanel = $"UpgradeUI/PurchaseConfirmPanel"
@onready var earningsLabel = $"UpgradeUI/earnings_label"

const WHISK_PRICE = 50
const CUTTER_PRICE = 50
const OVEN_PRICE = 50
const TUNE_UP_PRICE = 100
const DROID_1_PRICE = 150
const DROID_2_PRICE = 150
const PURCHASE_CONFIRM_ALPHA = 1
const FADE_SPEED = 0.75

var money = 2
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
	whiskPurchaseButton.pressed.connect(_purchase_whisk)
	cutterPurchaseButton.pressed.connect(_purchase_cutter)
	ovenPurchaseButton.pressed.connect(_purchase_oven)
	tuneUpPurchaseButton.pressed.connect(_purchase_tune_up)
	droid1PurchaseButton.pressed.connect(_purchase_droid_1)
	droid2PurchaseButton.pressed.connect(_purchase_droid_2)
	# Link the toggle functions with their respective buttons
	whiskToggle.pressed.connect(_toggle_whisk)
	cutterToggle.pressed.connect(_toggle_cutter)
	ovenToggle.pressed.connect(_toggle_oven)
	tuneUpToggle.pressed.connect(_toggle_tune_up)
	droid1Toggle.pressed.connect(_toggle_droid_1)
	droid2Toggle.pressed.connect(_toggle_droid_2)
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

func _purchase_whisk():
	if money >= WHISK_PRICE:
		money -= WHISK_PRICE
		justPurchased = true
		# Hide the purchase button
		whiskPurchaseButton.disabled = true
		whiskPurchaseButton.visible = false
		#Reveal the toggle button
		whiskToggle.disabled = false
		whiskToggle.visible = true
		# Activate the whisk powerup after purchase
		whiskToggle.button_pressed = true
		_toggle_whisk()
		# Change focus to the toggle that just activated
		whiskToggle.grab_focus()
	else:
		insufficientFunds = true

func _purchase_cutter():
	if money >= CUTTER_PRICE:
		money -= CUTTER_PRICE
		justPurchased = true
		# Hide the purchase button
		cutterPurchaseButton.disabled = true
		cutterPurchaseButton.visible = false
		#Reveal the toggle button
		cutterToggle.disabled = false
		cutterToggle.visible = true
		# Activate the cutter powerup after purchase
		cutterToggle.button_pressed = true
		_toggle_cutter()
		# Change focus to the toggle that just activated
		cutterToggle.grab_focus()
	else:
		insufficientFunds = true

func _purchase_oven():
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
		# Activate the oven powerup after purchase
		ovenToggle.button_pressed = true
		_toggle_oven()
		# Change focus to the toggle that just activated
		ovenToggle.grab_focus()
	else:
		insufficientFunds = true

func _purchase_tune_up():
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
		# Activate the whisk powerup after purchase
		tuneUpToggle.button_pressed = true
		_toggle_tune_up()
		# Change focus to the toggle that just activated
		tuneUpToggle.grab_focus()
	else:
		insufficientFunds = true

func _purchase_droid_1():
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
		# Activate the droid powerup after purchase
		droid1Toggle.button_pressed = true
		_toggle_droid_1()
		# Change focus to the toggle that just activated
		droid1Toggle.grab_focus()
	else:
		insufficientFunds = true

func _purchase_droid_2():
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
		# Activate the droid powerup after purchase
		droid2Toggle.button_pressed = true
		_toggle_droid_2()
		# Change focus to the toggle that just activated
		droid2Toggle.grab_focus()
	else:
		insufficientFunds = true

func _toggle_whisk():
	whiskActivated = whiskToggle.button_pressed
	if whiskActivated:
		whiskLabel.text = "Electric Whisk active"
	else:
		whiskLabel.text = "Electric Whisk inactive"

func _toggle_cutter():
	cutterActivated = cutterToggle.button_pressed
	if cutterActivated:
		cutterLabel.text = "Dual-Wield Cookie Cutters active"
	else:
		cutterLabel.text = "Dual-Wield Cookie Cutters inactive"

func _toggle_oven():
	ovenActivated = ovenToggle.button_pressed
	if ovenActivated:
		ovenLabel.text = "Oven-O'-Matic 5090Ti active"
	else:
		ovenLabel.text = "Oven-O'-Matic 5090Ti inactive"

func _toggle_tune_up():
	tuneUpActivated = tuneUpToggle.button_pressed
	if tuneUpActivated:
		tuneUpLabel.text = "Tune Up active"
	else:
		tuneUpLabel.text = "Tune Up inactive"

func _toggle_droid_1():
	droid1Activated = droid1Toggle.button_pressed
	if droid1Activated:
		droid1Label.text = "Chef Droid 1 active"
	else:
		droid1Label.text = "Chef Droid 1 inactive"

func _toggle_droid_2():
	droid2Activated = droid2Toggle.button_pressed
	if droid2Activated:
		droid2Label.text = "Chef Droid 2 active"
	else:
		droid2Label.text = "Chef Droid 2 inactive"

func _on_next_day_pressed():
	emit_signal("upgrading_finished")
