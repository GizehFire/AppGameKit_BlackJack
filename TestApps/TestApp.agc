	
SetWindowSize( MAX_WINDOW_SIZE_X, MAX_WINDOW_SIZE_Y, 0 )
SetWindowAllowResize( 1 ) // allow the user to resize the window

		// set  display properties

SetVirtualResolution( MAX_WINDOW_SIZE_X, MAX_WINDOW_SIZE_Y ) // doesn't have to match the window
SetOrientationAllowed( 1, 1, 1, 1 ) // allow both portrait and landscape on mobile devices
SetSyncRate( 30, 0 ) // 30fps instead of 60 to save battery
SetScissor( 0,0,0,0 ) // use the maximum available screen space, no black borders
UseNewDefaultFonts( 1 )

#constant MAX_WINDOW_SIZE_X		= 	1024
#constant MAX_WINDOW_SIZE_Y		= 	768

do
	
	 // DrawLine( 500, 700, 300, 300, 255,255,0 ) 
	 DrawLine( 0, 0, MAX_WINDOW_SIZE_X-1, MAX_WINDOW_SIZE_Y-1, 255,255,0 ) 

	print("Test")
	Sync ()

loop