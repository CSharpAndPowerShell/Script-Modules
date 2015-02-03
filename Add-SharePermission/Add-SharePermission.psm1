#requires -RunAsAdministrator
#requires -Version 4.0
Function Add-SharePermission {
    <#
    .SYNOPSIS
    Agrega permisos a recursos compartidos, en equipos y servidores.
    
    .DESCRIPTION
    Esta función necesita de todos sus parámetros. Le da permisos a un usuario o a un grupo sobre un recurso compartido.
    El parámetro "Access" permite únicamente los siguientes modificadores:
        FullControl - acceso total
        Change - permiso de cambiar
        Read - sólo lectura
 
    .EXAMPLE
    Add-SharePermission -Sharename "Casa" -User "Padres" -Access "FullControl"
 
    .NOTES
    Escrito por Cristopher Robles
 
    .LINK
    https://github.com/PowerShellScripting
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true,ValueFromPipeline=$true,Position=0,ValueFromPipelineByPropertyName=$true,HelpMessage="Nombre del recurso compartido existente.")]
        [string]$Sharename,

        [Parameter(Mandatory=$true,ValueFromPipeline=$true,Position=1,ValueFromPipelineByPropertyName=$true,HelpMessage="Nombre del usuario o grupo al que le será compatido el recurso.")]
        [string]$User,

        [Parameter(ValueFromPipeline=$true,Position=2,ValueFromPipelineByPropertyName=$true,HelpMessage="Nivel de acceso que se le otorgará al usuario o grupo.")]
        [ValidateSet("Read", "Change", "FullControl")]
        [string]$Access = "Read"
    )
	
    Process {
        if ((Get-WmiObject -Class "Win32_Share").Name.Contains($Sharename)) {
			try {
	            $Tclass = [WMIClass]"\\$env:COMPUTERNAME\root\cimv2:Win32_Trustee"
	            $Trustee = $TClass.CreateInstance()
	            $Trustee.Domain = $ENV:USERDOMAIN
	            $Trustee.Name = $User
	            $aclass = [WMIClass]"\\$ENV:COMPUTERNAME\root\cimv2:Win32_ACE"
	            $ACE = $AClass.CreateInstance()
				Switch ($Access) {
	                'Read' {
						$ACE.AccessMask = 1179817
					}
	                'Change' {
						$ACE.AccessMask = 1245631
					}
	                'FullControl' {
						$ACE.AccessMask = 2032127
					}
				}
	            $ACE.AceFlags = 0
	            $ACE.AceType = 0
	            $ACE.Trustee = $Trustee
	            $LSSS = Get-WmiObject -Class Win32_LogicalShareSecuritySetting -Filter "Name='$sharename'" -ComputerName $env:COMPUTERNAME
	            $SD = Invoke-WmiMethod -InputObject $LSSS -Name GetSecurityDescriptor | Select -ExpandProperty Descriptor
	            $SClass = [WMIClass]"\\$ENV:COMPUTERNAME\root\cimv2:Win32_SecurityDescriptor"
	            $NewSD = $SClass.CreateInstance()
	            $NewSD.ControlFlags = $SD.ControlFlags
	            foreach ($ACE0 in $SD.DACL) { $NewSD.DACL += $ACE0 }
	            $NewSD.DACL += $ACE
	            $Share = Get-WmiObject -Class Win32_LogicalShareSecuritySetting -Filter "Name='$ShareName'"
	            $Share.SetSecurityDescriptor($NewSD) | Out-Null
			}
			Catch {
				[void][reflection.assembly]::Load("System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
				[void][System.Windows.Forms.MessageBox]::Show("$_","Error")
			}
        }
        else {
			[void][reflection.assembly]::Load("System.Windows.Forms, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
			[void][System.Windows.Forms.MessageBox]::Show("No existe el recurso compartido '$ShareName'!`nImposible asignar permisos.","Advertencia")
        }
    }
}

Export-ModuleMember Add-SharePermission