; Testing environment
; Browser: Chromium 52
; Language: English
; Animation/Resolution Settings = [Animation Settings : "Standard", Resolution Settings : "High"]
; Browser Version Settings = [Automatic Resizing : "Off", Window Size : "Medium"]

#Include gbfscriptConfigUtilities.ahk

SetTimer, ForceExitApp, 7600000 ; 1h

CoordMode Pixel, Relative
CoordMode Mouse, Relative

global maxBattleNonActions := 30
global maxWaitCount := 5 ;Timeout for quest screen
global maxRounds := 50
global globalTimeoutMax := 85 ;Set to a bit more than what 1 cycle would take, it'll be considered a time out if we exceed this
global post_attack_button_delay := 5000

global searchURL := "http://game.granbluefantasy.jp/#event/teamraid026" ;This is the home URL, where we'll look for the quest to be started and where we'll return if lost

global summonIconType := fav_icon ;You'll need to change the summon icons if you're not using viramate's favourites. Somehow using it makes the icons render differently.
global summonIconTypeSelected := fav_icon_selected 

global selectOne := "explus1.png"
global selectTwo := "explus2.png"
global selectOne_X := 0
global selectOne_Y := 0
global selectTwo_X := 0
global selectTwo_Y := 0

global genericActions := [selectOne, selectTwo, long_ok, drop_down]
global battleActions := [attack_button, ok_button, revive_button, rejoin_button]

Gui, Add, ListView, x6 y6 w400 h500 vLogbox LVS_REPORT, %A_Now%|Activity
	LV_ModifyCol(1, 60)
	GuiControl, -Hdr, Logbox
	Gui, Show, w410 h505, GBF Bot Log

updateLog("[F1] Resize window [F2] Start/Pause [Esc] Exit")
Pause

;----------------------------------------------
;Main Loop
;----------------------------------------------
Loop
{
	Sleep, % default_interval
	globalTimeout := globalTimeout + 1
	updateLog("Glogal timeout: " . globalTimeout)

	if (globalTimeout >= globalTimeoutMax)
	{
		updateLog("Timed out. Refreshing page.")

		if (usePushBullet = True)
		{
			updateLog("Push sent, status: " . PB_PushNote("Warning, bot timed out"))
		}

		globalTimeout := 0
		Send, {F5}
		Continue
	}

	sURL := GetActiveChromeURL()
	WinGetClass, sClass, A

	If (sURL != "")
	{
		if InStr(sURL, searchBattle)
		{
			updateLog("-----In Battle-----")
			searchResult := multiImageSearch(coordX, coordY, battleActions)

			if InStr(searchResult, attack_button)
			{
				if (attackTurns = 0)
				{
					;First turn actions
					updateLog("Battle sequence, battle turn count = " . attackTurns)
					battleNonActions := 0
					attackTurns := attackTurns + 1
					SetOugi(False)
					ClickSummon(6)
					ClickSkill([33,31,21,14,13,12])

					UseSticker(phalanx_sticker)			

					CheckSkill([33,31,21,14,13,12])

					RandomClickWide(attack_button_X, attack_button_Y, clickVariance)				
					Sleep, post_attack_button_delay
				}
				else if (attackTurns = 1)
				{
					updateLog("Battle sequence, battle turn count = " . attackTurns)
					battleNonActions := 0
					attackTurns := attackTurns + 1
					SetOugi(False)

					ClickSkill(21)

					UseSticker(laserfocus_sticker)

					CheckSkill(21)

					RandomClickWide(attack_button_X, attack_button_Y, clickVariance)
					Sleep, % post_attack_button_delay
				}
				else if (attackTurns = 2)
				{
					updateLog("Battle sequence, battle turn count = " . attackTurns)
					battleNonActions := 0
					attackTurns := attackTurns + 1
					SetOugi(False)

					ClickSkill(21)

					CheckSkill(21)

					RandomClickWide(attack_button_X, attack_button_Y, clickVariance)
					Sleep, % post_attack_button_delay
				}
				else if (attackTurns = 3)
				{
					updateLog("Battle sequence, battle turn count = " . attackTurns)
					battleNonActions := 0
					attackTurns := attackTurns + 1
					UsePot(0)
					SetOugi(False)

					ClickSkill([21,11])

					CheckSkill([21,11])

					RandomClickWide(attack_button_X, attack_button_Y, clickVariance)
					Sleep, % post_attack_button_delay
				}
				else if (attackTurns = 4)
				{
					updateLog("Battle sequence, battle turn count = " . attackTurns)
					battleNonActions := 0
					attackTurns := attackTurns + 1
					UsePot(3)
					UsePot(4)
					SetOugi(True)

					ClickSkill([21,412])

					CheckSkill([21,412])

					RandomClickWide(attack_button_X, attack_button_Y, clickVariance)
					Sleep, % post_attack_button_delay
					Sleep, % post_ougi_delay
					Send, {F5}
				}
				else if (attackTurns = 5)
				{
					updateLog("Battle sequence, battle turn count = " . attackTurns)
					battleNonActions := 0
					attackTurns := attackTurns + 1
					ClickSummon(4)
					SetOugi(True)

					ClickSkill([43,21])

					CheckSkill([43,21])

					RandomClickWide(attack_button_X, attack_button_Y, clickVariance)
					Sleep, % post_attack_button_delay
				}
				else if (attackTurns = 6)
				{
					updateLog("Battle sequence, battle turn count = " . attackTurns)
					battleNonActions := 0
					attackTurns := attackTurns + 1
					SetOugi(True)

					ClickSkill([42,33,31,21,22,23,13,12])

					CheckSkill([42,33,31,21,22,23,13,12])

					RandomClickWide(attack_button_X, attack_button_Y, clickVariance)				
					Sleep, % post_attack_button_delay
					Sleep, % post_ougi_delay
					Send, {F5}
					
				}
				else if (attackTurns = 7)
				{
					updateLog("Battle sequence, battle turn count = " . attackTurns)
					attackTurns := attackTurns + 1
					SetOugi(True)

					ClickSkill([32,21])

					CheckSkill([32,21])

					RandomClickWide(attack_button_X, attack_button_Y, clickVariance)
					Sleep, % post_attack_button_delay
				}
				else if (attackTurns >= 8)
				{
					updateLog("Battle sequence, battle turn count = " . attackTurns)
					attackTurns := attackTurns + 1
					SetOugi(True)

					RandomClickWide(attack_button_X, attack_button_Y, clickVariance)
					Sleep, % post_attack_button_delay
				}

				else
				{
					;Fallback action for our turn
					Send, {F5}
				}
			}
			
			else if InStr(searchResult, ok_button)
			{
				;Try to handle network errors etc.
				updateLog("Wild OK button has appeared, clicking")
				RandomClick(coordX + ok_button_offset_X, coordY + ok_button_offset_Y, 0)
			}

			else if InStr(searchResult, revive_button) or InStr(searchResult, rejoin_button)
			{
				;Attempt to use guild war revive pot when dead
				updateLog("We appear to be dead, we'll try to revive")
				PB_PushNote("ded T_T")
				RandomClick(coordX, coordY, clickVariance)
				Sleep, default_interval
				RandomClick(236, 483, clickVariance)
			}

			else
			{
				updateLog("Battle action not taken, battle non action count = " . battleNonActions)
				
				if (battleNonActions >= maxBattleNonActions) ; Comment out this statement if you're autoing
				{
					Send, {F5} ;It's been awhile since we could see our attack button so we're refreshing
					battleNonActions := 0
				}

				else
				{
					battleNonActions := battleNonActions + 1
				}
			}
			continue
		}

		else if InStr(sURL, searchSelectSummon)
		{
			updateLog("-----In Select Summon-----")

			Send {WheelUp}
			
			waitCount = 0
			
			selectSummonAutoSelect := [select_party_auto_select, summonIconType, summonIconTypeSelected]
			searchResult := multiImageSearch(coordX, coordY, selectSummonAutoSelect)
			
			if InStr(searchResult, select_party_auto_select)
			{
				updateLog("Party Confirm detected, clicking OK button")
				RandomClick(coordX + select_party_auto_select_offset_X, coordY + select_party_auto_select_offset_Y, clickVariance) 
				continue
			}
			else if InStr(searchResult, summonIconType)
			{
				updateLog("Clicking on summon icon")
				RandomClick(coordX + summonIconType_offset_X, coordY + summonIconType_offset_Y, clickVariance)
			}
			else if InStr(searchResult, summonIconTypeSelected)
			{
				updateLog("Clicking on first summon")
				RandomClick(first_summon_X, first_summon_Y, clickVariance)
			}
			continue
		}
		
		else if InStr(sURL, searchURL)
		{
			updateLog("-----In Quest Select Screen-----")
			Sleep, % default_interval
			
			searchResult := multiImageSearch(coordX, coordY, genericActions)
			if InStr(searchResult, selectOne)
			{
				updateLog("Quest icon detected, clicking")
				waitCount := 0
				RandomClick(coordX + selectOne_X, coordY + selectOne_Y, clickVariance)
			}
			else if InStr(searchResult, selectTwo)
			{
				updateLog("Clicking quest")
				waitCount := 0
				RandomClick(coordX + selectTwo_X, coordY + selectTwo_Y, clickVariance)
			}
			else if InStr(searchResult, drop_down)
			{ 
				updateLog("Not Enough AP dialog found, clicking Use button")
				waitCount := 0
				RandomClick(coordX + drop_down_offset_X, coordY + drop_down_offset_Y, clickVariance)

				Sleep, long_interval

				RandomClick(coordX + drop_down_offset2_X, coordY + drop_down_offset2_Y, clickVariance)
			}
			else if InStr(searchResult, ok_button)
			{
				updateLog("Wild OK button has appeared, clicking")
				RandomClick(coordX + ok_button_offset_X, coordY + ok_button_offset_Y, 0)
			}
			else 
			{
				if(waitCount >= maxWaitCount)
				{
					updateLog("Waited long enough, lets reload")
					Sleep, % default_delay
					waitCount := 0
					GoToPage(searchURL)
				}
				else
				{
					updateLog("Nothing was found")
					
					waitCount := waitCount + 1
				}
			}

			continue
		}

		else if InStr(sURL, searchResults)
		{
			updateLog("-----In Results Screen-----")
			attackTurns := 0
			globalTimeout := 0
			battleNonActions := 0
			
			resultScreenCycles := resultScreenCycles + 1
			curRound += 1

			if (maxRounds > 0) and (curRound >= maxRounds)
			{
				if (usePushBullet = True)
				{
					PB_Message := "Target of " . maxRounds . " reached. Shutting down."
					updateLog("Push sent, status: " . PB_PushNote(PB_Message))
				}
				Sleep, long_interval
				ExitApp
			}
			else if (timerElapsed = 1)
			{
				if (usePushBullet = True)
				{
					updateLog("Push sent, status: " . PB_PushNote("Time elapsed. " . curRound . " rounds completed. Shutting down."))
				}
				Sleep, long_interval
				ExitApp
			}
			
			Sleep, results_delay
			updateLog("Going to quest select page")
			GoToPage(searchURL)
			continue
		}

		else if InStr(sURL, topPage)
		{			
			updateLog("We're at top page, clicking continue")
			Sleep, short_interval
			RandomClick(207, 195, clickVariance)
		}
		
		else if InStr(sURL, authPage)
		{
			;Primitive routine for clicking the mobage icon
			updateLog("We're at auth page, clicking the mobage button")
			Sleep, short_interval			
			RandomClick(199, 197, clickVariance)
		}

		else
		{
			updateLog("Huh? We're at " . sURL)
			GoToPage(searchURL)
			continue
		}
	}
	Else
		updateLog("Chrome not detected (" . sClass . ")")
}
Return

;----------------------------------------------
;Keybinds
;----------------------------------------------

F1::
updateLog("Resizing window to " . GBF_winWidth . " x " . GBF_winHeight)
ResizeWin(GBF_winWidth, GBF_winHeight)
Return

F12::Pause

GuiClose:
ExitApp

Esc::
ExitApp

ForceExitApp:
SetTimer,  ForceExitApp, Off
timerElapsed := 1
Return
