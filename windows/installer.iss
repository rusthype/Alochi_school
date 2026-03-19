[Setup]
AppName=A'lochi Maktab
AppVersion=1.0.0
AppPublisher=A'lochi
AppPublisherURL=https://alochi.uz
AppSupportURL=https://alochi.uz
DefaultDirName={autopf}\AlochiMaktab
DefaultGroupName=A'lochi Maktab
OutputDir=Output
OutputBaseFilename=AlochiMaktab-Setup
Compression=lzma
SolidCompression=yes
WizardStyle=modern
SetupIconFile=runner\resources\app_icon.ico
UninstallDisplayIcon={app}\alochi_maktab.exe
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog
ArchitecturesInstallIn64BitMode=x64compatible

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "..\build\windows\x64\runner\Release\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Icons]
Name: "{group}\A'lochi Maktab"; Filename: "{app}\alochi_maktab.exe"
Name: "{group}\Uninstall A'lochi Maktab"; Filename: "{uninstallexe}"
Name: "{commondesktop}\A'lochi Maktab"; Filename: "{app}\alochi_maktab.exe"; Tasks: desktopicon

[Run]
Filename: "{app}\alochi_maktab.exe"; Description: "{cm:LaunchProgram,A'lochi Maktab}"; Flags: nowait postinstall skipifsilent
