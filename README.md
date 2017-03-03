# VCard_Reader
Written in AutoHotKey to extract details from a single VCard (V-Card) and export bits to keep in one file (with a separate file to log rejects)

Known problems:
<br>1) When there is too much data in the VCard, it makes it difficult for the information to fit on the screen. This will happen if there is a picture embedded in the vcard file. To get around this, either press enter for Yes or {tab} then enter for No. This will be easily removeable in an update - just don't let the rows into the output for the image... although it would probably require making a thisvcard_display variable to display without that line but keep thisvcard variable with the image so that it goes into the output...
<br>2) Variables might be an issue.
  
