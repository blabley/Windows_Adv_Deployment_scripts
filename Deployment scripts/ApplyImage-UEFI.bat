rem == ApplyImage-UEFI.bat ==

rem == These commands deploy a specified Windows
rem    image file to the Windows partition, and configure
rem    the system partition.

rem    Usage:   ApplyImage WimFileName 
rem    Example: ApplyImage E:\Images\ThinImage.wim ==

rem == Copy the image to the recovery partition ==
md R:\RecoveryImage
copy %1 R:\RecoveryImage\Install.wim

rem == Apply the image to the Windows partition ==
dism /Apply-Image /ImageFile:"R:\RecoveryImage\Install.wim" /Index:1 /ApplyDir:W:\

rem == Copy boot files to the System partition ==
W:\Windows\System32\bcdboot W:\Windows

:rem == Copy the Windows RE image to the
:rem    Windows RE Tools partition ==
md T:\Recovery\WindowsRE
xcopy /h W:\Windows\System32\Recovery\Winre.wim T:\Recovery\WindowsRE\

:rem == Register the location of the recovery tools ==
W:\Windows\System32\Reagentc /Setreimage /Path T:\Recovery\WindowsRE /Target W:\Windows

:rem == Register the location of the
:rem    push-button reset recovery image. ==
W:\Windows\System32\Reagentc /Setosimage /Path R:\RecoveryImage /Target W:\Windows /Index 1

:rem == Verify the configuration status of the images. ==
W:\Windows\System32\Reagentc /Info /Target W:\Windows
