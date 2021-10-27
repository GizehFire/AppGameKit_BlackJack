// Project: myBlackJack 
// Created: Begining September 2021

// #import_plugin MyNewPlugin


// declare and set Constants

SetConstant ()

// declare Varibale

SetVariable () 

// show all errors

SetErrorMode(2)

SetWindowsDeviceProperty ()


// Variablen mit Werten zuweisen

XButton = ( MAX_WINDOW_SIZE_X / 2 ) - ( MAX_DRAW_CARD_X_LENGH / 2 ) + ( MAX_DRAW_CARD_X_LENGH / 2 )
YButton = ( MAX_WINDOW_SIZE_Y / 2 ) - ( MAX_DRAW_CARD_Y_LENGH / 2 ) + ( MAX_DRAW_CARD_Y_LENGH / 2 )


// global post = 30 as integer //[IDEGUIADD],integer,post

// Grafik-Daten laden

backdrop0 	= LoadImage("blackjack/Blackjack-Cards_L.png")
CoverSheet	= LoadImage("blackjack/Coversheet_L.png")

CoverSheetCard = CreateSprite (CoverSheet)
SetSpriteSize(CoverSheetCard, MAX_DRAW_CARD_X_LENGH/2, MAX_DRAW_CARD_Y_LENGH / 2 )

// 52 Karten mischen und in einer Array eintragen

ShuffleCards ()

FillCardTable ()

PutCardPosXY ()

// SPR_CardsDeckFT[1] = CreateSprite (ID_CardsDeckFT[52])

FillCardToSprite ()
DeleteAnyArrays ()


 for a = 1 to 4 
 	
 	PutFourCards [a] = CardsDeckRandom [1]
 	CardsDeckRandom.remove(1)
 	 	
 	next a    

// CPU - Player

SetCPUCard ()

// Player

SetPlayerCard ()

// Build Buttons

MakeButton ()

// --> Hauptprogramm -->

do
	
	// If Pressed "exit"
		
	if GetVirtualButtonPressed(3) then end 
	
	// If Pressed "draw"	(Wenn der Spieler eine weitere Karte zieht)
	
	if GetVirtualButtonPressed(1) then Player_Pressed_Draw ()
		
	
    Sync ()
    
loop

// <-- Hauptprogramm <--

Function intern_debug ()
		
		Print ("BJ Cards")
		Print ("Cards: " + str(CardsDeckRandom.length))
		
		if GetSpriteExists(PlayerCardID) then Print("Card ID: " + str(PlayerCardID))
		if GetSpriteExists(PlayerCardID) then Print("Depth: " + str(GetSpriteDepth(PlayerCardID)))

	
EndFunction

Function Player_Pressed_Draw ()
	
	DrawCardNum = DrawCardNum + 1
		
		XButton_Move = 25
		YButton_Move = 25
				
		if DrawCardNum = 1
		
		XButton = XButton - 55
		YButton = YButton - 20
						
			endif
				
		XButton_Move = DrawCardNum * XButton_Move
		YButton_Move = DrawCardNum * YButton_Move
				
		PutFourCards [1] = CardsDeckRandom [1]
		CardsDeckRandom.remove(1)
		
		PlayerCardID = ViewAndSetCardXY ( PutFourCards[1],  (XButton + XButton_Move), (YButton - YButton_Move)) 
		
		GSetDepthCard = GSetDepthCard - 1
		
		SetSpriteDepth(PlayerCardID,GSetDepthCard)
		
		// XButton	=	BackupNum
		
	
	EndFunction

Function SetCPUCard ()
	
	local XPosButton 			as integer 	=	0
	local YPosButton 			as integer 	=	0
	local FirstCardShow			as integer 	= 	0
	local CoverSheetCardShow		as integer	=	0
	
	XPosButton = ( MAX_WINDOW_SIZE_X / 2 ) - ( MAX_DRAW_CARD_X_LENGH / 2 ) + (MAX_DRAW_CARD_X_LENGH / 2 )
	YPosButton = ( MAX_WINDOW_SIZE_Y / 2 ) - ( MAX_DRAW_CARD_Y_LENGH / 2 ) + (MAX_DRAW_CARD_Y_LENGH / 2 )
	
	FirstCardShow	= 	ViewAndSetCardXY ( PutFourCards[1],  XPosButton - 85, YPosButton - 275) 
	SetSpriteDepth ( FirstCardShow, GSetDepthCard )
	GSetDepthCard	=	(MAX_DEPTH_CARD  - 	2)
	
	SecondsCardShow	=	ViewAndSetCardXY ( PutFourCards[3],  XPosButton, YPosButton - 275) 
	SetSpriteDepth ( SecondsCardShow, GSetDepthCard )
	GSetDepthCard	=	(MAX_DEPTH_CARD  - 	1)
		
	SetSpritePosition(CoverSheetCard, XPosButton, YPosButton - 275 )
	SetSpriteDepth ( CoverSheetCard, MAX_DEPTH_CARD )
		
	SetSpriteVisible(SecondsCardShow,0)
	
EndFunction

Function SetPlayerCard ()
	
	local FirstCardShow		as integer 	= 	0
	local SecondCardShow		as integer	=	0

	FirstCardShow		=	ViewAndSetCardXY ( PutFourCards[2],  XButton - 85, YButton) 
	GSetDepthCard		=	( MAX_DEPTH_CARD  - 	3 )
	SetSpriteDepth ( FirstCardShow, GSetDepthCard )
	
	SecondCardShow	=	ViewAndSetCardXY ( PutFourCards[4],  XButton - 55, YButton - 20) 
	GSetDepthCard	=	(MAX_DEPTH_CARD  - 	4 )
	SetSpriteDepth ( SecondCardShow, GSetDepthCard )
	
	
	
	
EndFunction

Function MakeButton ()

AddVirtualButton(1, XButton - 50, YButton + 175, 75)
AddVirtualButton(2, XButton + 50, YButton + 175, 75)
AddVirtualButton(3, MAX_WINDOW_SIZE_X-80, MAX_WINDOW_SIZE_Y-80, 75)

SetVirtualButtonText(1,"Ziehen")
SetVirtualButtonText(2,"Halten")
SetVirtualButtonText(3,"Exit")



EndFunction

Function ShuffleCards ()
	
	local n 		as integer
	local element1	as integer
	local element2	as integer
	local tempNumber	as integer
	
	For n = 1 to 52
    
    	CardsDeckRandom[n] = n
    	
    Next n
 
// Shuffle the numbers.

	For n = 1 to 52

    	element1 = Random(1, 52)
    	element2 = Random(1, 52)
    
    	tempNumber = CardsDeckRandom[element1]
    
    	CardsDeckRandom[element1] = CardsDeckRandom[element2]
    	CardsDeckRandom[element2] = tempNumber

	Next n
	

endfunction

Function ViewAndSetCardXY (CardNum, XPOS, YPOS as integer)

CardResult as integer = 0

if CardNum < 1 
	
	CardResult = 1
	
	endif

if CardNum > 52 
	
	CardResult = 2
	
	endif

if CardResult = 0 	

SetSpritePosition(SPR_CardsDeckFT[CardNum], XPOS,YPOS)
SetSpriteSize(SPR_CardsDeckFT[CardNum], MAX_DRAW_CARD_X_LENGH/2, MAX_DRAW_CARD_Y_LENGH/2)
SetSpriteVisible(SPR_CardsDeckFT[CardNum],1)
// GetSpriteImageID()
else

	Zahltreffer = "Error Code: " + str(CardResult)
	Message(Zahltreffer + " [Program abort]")
	end  // Program abort

endif



endfunction SPR_CardsDeckFT[CardNum]

Function DeleteAnyArrays ()

undim CardsDeckX[]
undim CardsDeckY[]
undim CardsDeckFT[]
undim ID_CardsDeckFT[]

EndFunction

Function FillCardToSprite ()

for a = 1 to 52


SPR_CardsDeckFT[a] = CreateSprite (ID_CardsDeckFT[a])
SetSpriteVisible(SPR_CardsDeckFT[a],0)

next a

endfunction

Function FillCardTable ()
	
	local a, b, c as integer
	
	b = 12
	c = 220 + 20


for a = 0 to 3
	
	CardsDeckY[ a ] = b
	
	b = b + c
		
	next a


b = 8
c = 180


for a = 0 to 12
	
	CardsDeckX[a] = b
	
	b = b + c
		
	next a
	
	
	c=1
	
	for a = 0 to 12 
		
		CardsDeckFT[c] = CardsDeckX[a]
		c=c+1
		
		next a
	
	b=14
			
	for a = 0 to 3 
		
		CardsDeckFT[b] = CardsDeckY[a]
		b=b+1
		
		next a	
	
	
	endfunction

Function PutCardPosXY ()
	
	local SetCardPosXY 	as integer	= 0
	local SLoop			as integer 	= 52
	local SLoopZaehler	as integer	= 1
			
for SLoopZaehler = 1 to SLoop
	
	SetCardPosXY = SetCardPosXY + 1	
		
	if (SLoopZaehler >= 1) and (SLoopZaehler <= 13)
		
		ID_CardsDeckFT[SLoopZaehler] = CopyImage(backdrop0, CardsDeckFT[SetCardPosXY],CardsDeckFT[14], MAX_DRAW_CARD_X_LENGH,MAX_DRAW_CARD_Y_LENGH)
		
		// Zahltreffer = "between 1 and 13"	
	
	endif
	
	if (SLoopZaehler > 13) and (SLoopZaehler <= 26)
		
		SetCardPosXY=SLoopZaehler-13
		ID_CardsDeckFT[SLoopZaehler] = CopyImage(backdrop0, CardsDeckFT[SetCardPosXY],CardsDeckFT[15], MAX_DRAW_CARD_X_LENGH,MAX_DRAW_CARD_Y_LENGH)
	
		// Zahltreffer = "between 14 and 26"
	
	endif

	if (SLoopZaehler > 26) and (SLoopZaehler <= 39)
		
		SetCardPosXY=SLoopZaehler-26
		ID_CardsDeckFT[SLoopZaehler] = CopyImage(backdrop0, CardsDeckFT[SetCardPosXY],CardsDeckFT[16], MAX_DRAW_CARD_X_LENGH,MAX_DRAW_CARD_Y_LENGH)
		
		// Zahltreffer = "between 27 and 39"
	
	endif
	
	if (SLoopZaehler > 39) and (SLoopZaehler <= 52)
		
		SetCardPosXY=SLoopZaehler-39
		ID_CardsDeckFT[SLoopZaehler] = CopyImage(backdrop0, CardsDeckFT[SetCardPosXY],CardsDeckFT[17], MAX_DRAW_CARD_X_LENGH,MAX_DRAW_CARD_Y_LENGH)
		
		// Zahltreffer = "between 40 and 52"
	
	endif
				
	next SLoopZaehler
	
endfunction

Function SetWindowsDeviceProperty ()
	
	// set window properties and display properties

	SetWindowTitle( "myBlackJack" )
	SetWindowSize( MAX_WINDOW_SIZE_X, MAX_WINDOW_SIZE_Y, 0 )
	SetWindowAllowResize( 1 ) // allow the user to resize the window

	// set  display properties

	SetVirtualResolution( MAX_WINDOW_SIZE_X, MAX_WINDOW_SIZE_Y ) // doesn't have to match the window
	SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
	SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
	SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
	UseNewDefaultFonts( 1 )

	
	EndFunction



Function SetConstant ()
	
	#constant MAX_SCORE_CARD			=	21
	
	#constant MAX_WINDOW_SIZE_X		= 	1024
	#constant MAX_WINDOW_SIZE_Y		= 	768

	#constant MAX_DRAW_CARD_X_LENGH	= 	160
	#constant MAX_DRAW_CARD_Y_LENGH	= 	220

	#constant MAX_DEPTH_CARD			= 	40	
	
	EndFunction

Function SetVariable ()
	
	#option_explicit
	
	global PlayerScore			as integer
	global CPUScore				as integer
	
	global backdrop0 			as integer = 0
	global ID_CardsDeckFT 		as integer[52]
	global SPR_CardsDeckFT 		as integer[52]
	global CardsDeckRandom 		as integer[52]
	
	global CardsDeckFT 			as integer[17]
	global CardsDeckX 			as integer[12]
	global CardsDeckY 			as integer[3]
	
	global Zahltreffer 			as string
	global a,b,c 				as integer
	global CardsErrorCode 		as integer
	
	global CoverSheet 			as integer
	global CoverSheetCard 		as integer
		
	global PutFourCards 			as integer[4]
	global SecondsCardShow 		as integer 	= 0
	global DeckButtonBoolean 	as integer 	= 1
	
	global XButton 				as integer
	global YButton 				as integer
	
	global DrawCardNum			as	integer	=	0
	global BackupNum				as	integer	=	0
	
	global XButton_Move			as	integer	=	0
	global YButton_Move 			as	integer	= 	0
	
	global PlayerCardID			as	integer	=	0
	global GSetDepthCard			as	integer	=	MAX_DEPTH_CARD

	
endfunction
