Function Set-Drives
{
    <#
    .SYNOPSIS
    Restringe el acceso u oculta las unidades seleccionadas, al ocultar no se muestran las unidades en "Equipo", al restringir no se permite al acceso a las unidades.
    
    .DESCRIPTION
    Esta función necesita al menos uno de los siguientes parámetros; "NoDrives" oculta las unidades seleccionadas, "NoViewOnDrive" restringe el acceso a las unidades seleccionadas, "Disable" deshabilita las restricción a las unidades y/o particiones.

    .EXAMPLE
    Set-Drives -NoDrives -Drives "C"
    Set-Drives -NoDrives -Drives "C","D","F"
    Set-Drives -NoViewOnDrive -Drives "D"
    Set-Drives -NoViewOnDrive -Drives "D","F"
    Set-Drives -Disable
 
    .NOTES
    Escrito por Cristopher Robles
 
    .LINK
    https://github.com/CSharpAndPowerShell/Script-Modules
    #>
	
	Param
	(
		[Parameter(Position = 0, HelpMessage = "Ocultar unidades.")]
		[switch]$NoDrives = $false,
		[Parameter(Position = 0, HelpMessage = "Restringe acceso a unidades.")]
		[switch]$NoViewOnDrive = $false,
		[Parameter(Position = 0, HelpMessage = "Deshabilita todos los cambios hechos a las unidades.")]
		[switch]$Disable = $false,
		[Parameter(Position = 1, HelpMessage = "Letra de la unidad a renombrar.")]
		[ValidateNotNullOrEmpty()]
		[array]$Drives
	)
	
	If ($Disable)
	{
		Remove-Item -Path HKLM:\SOFTWARE\Microsoft\Windows\Currentversion\Policies\Explorer -Force
	}
	Else
	{
		[int]$Value = 0
		$ID = @{ A = 1; B = 2; C = 4; D = 8; E = 16; F = 32; G = 64; H = 128; I = 256; J = 512; K = 1024; L = 2048; M = 4096; N = 8192; O = 16384; P = 32768; Q = 65536; R = 131072; S = 262144; T = 524288; U = 1048576; V = 2097152; W = 4194304; X = 8388608; Y = 16777216; Z = 33554432 }
		Foreach ($D in $Drives)
		{
			$Value += $ID.$D
		}
		#Aplicando cambios
		If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\Currentversion\Policies\Explorer"))
		{
			New-Item -Path HKLM:\SOFTWARE\Microsoft\Windows\Currentversion\Policies -Name Explorer -Force -ErrorAction SilentlyContinue | Out-Null
		}
		If ($NoDrives)
		{
			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\Currentversion\Policies\Explorer -PropertyType DWORD -Name NoDrives -Value $Value -Force | Out-Null
		}
		If ($NoViewOnDrive)
		{
			New-ItemProperty -Path HKLM:\SOFTWARE\Microsoft\Windows\Currentversion\Policies\Explorer -PropertyType DWORD -Name NoViewOnDrive -Value $Value -Force | Out-Null
		}
	}
}