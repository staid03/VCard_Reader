#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#singleinstance , force

;	Version	Date		Author		Notes
;	0.1	02-MAR-2017	Staid03		Initial
;	0.2	03-MAR-2017	Staid03		Update to stop images in VCards from taking up all the screen space (and hiding the YES/NO buttons)
;						Add subroutine to count VCards and display count in script.

;Written in AutoHotKey to extract details from a single VCard (V-Card) and export bits to keep in one file (with a separate file to log rejects)
;It's incredibly simple and something that got the job done that I needed.

;Known problems:
;1) When there is too much data in the VCard, it makes it difficult for the information to fit on the screen. This will happen if there is a picture embedded in the vcard file. To get around this, either press enter for Yes or {tab} then enter for No. This will be easily removeable in an update - just don't let the rows into the output for the image... although it would probably require making a thisvcard_display variable to display without that line but keep thisvcard variable with the image so that it goes into the output...
;2) Variables might be an issue.

FormatTime , aTime , , yyyyMMMdd_HHmmss

iFolder = D:\					;update this as you see fit
inFile = %iFolder%\Contacts.vcf
outFileKeep = %iFolder%\Contacts_list_Keep_%aTime%.vcf
outFileReject = %iFolder%\Contacts_list_Reject_%aTime%.vcf
VCardCounterNum = 0

VCardOpener = BEGIN:VCARD
VCardCloser = END:VCARD
VCardVersion = VERSION:

goSub , VCardCounter


;loop through the VCard file looking for keywords and creating individual detail blocks to show to users

Loop , Read , %inFile% , 
{
	ifInString , a_LoopReadLine , %VCardCloser%
	{
		MsgBox ,4,, Keep this? %a_tab%%a_tab%%thisVCardDisplay%
		ifMsgBox , yes
		{
			VCardFile = %outFileKeep%
		}
		else 
		{
			VCardFile = %outFileReject%
		}
		gosub , VCardWriter
	}
	ifInString , a_LoopReadLine , %VCardOpener%
	{
		VCardCounterNum++
		thisVCard =			;reset the variable		
		thisVCardDisplay = 		;reset the variable
		thisVCardDisplay = Number: %VCardCounterNum%/%VCardCounterTotalNum%`n`n		;add the counter to the top of the display
		Continue
	}
	ifInString , a_LoopReadLine , %VCardVersion%
	{
		Continue
	}
	StringLeft , spaceCheck , a_LoopReadLine , 1
	ifEqual , spaceCheck , %a_space%
	{
		thisVCard = %thisVCard%%a_LoopReadLine%`n
		Continue
	}
	thisVCardDisplay = %thisVCardDisplay%%a_LoopReadLine%`n
	thisVCard = %thisVCard%%a_LoopReadLine%`n
}
Return

VCardWriter:
{
	outLine = %VCardOpener%`n%VCardVersion%`n%thisVCard%%VCardCloser%
	fileappend , %outLine%`n, %VCardFile%
}
Return 

VCardCounter:
{
	VCardCounterTotalNum = 0
	Loop , Read , %inFile% , 
	{
		ifInString , a_LoopReadLine , %VCardOpener%
		{
			VCardCounterTotalNum++
		}
	}
}
Return 