#requires -RunAsAdministrator
#requires -Modules Show-MessageBox
Function Add-SharePermission
{
    <#
    .SYNOPSIS
    Agrega permisos a recursos compartidos, en equipos y servidores.
    
    .DESCRIPTION
    Le da permisos a un usuario o a un grupo sobre un recurso compartido.
	
	.PARAMETER  <Sharename [String]>
	Especifica el nombre del recurso compartido.
	
	.PARAMETER  <User [String]>
	Especifica el nombre del usuario o grupo al que se le asignará el permiso.
	
	.PARAMETER  <Access [String]>
	Especifica el tipo de acceso que se le da asignará al usuario.
	permite únicamente los siguientes modificadores:
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
	
	Param (
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName = $true, HelpMessage = "Nombre del recurso compartido existente.")]
		[String]$Sharename,
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 1, ValueFromPipelineByPropertyName = $true, HelpMessage = "Nombre del usuario o grupo al que le será compatido el recurso.")]
		[String]$User,
		[Parameter(ValueFromPipeline = $true, Position = 2, ValueFromPipelineByPropertyName = $true, HelpMessage = "Nivel de acceso que se le otorgará al usuario o grupo.")]
		[ValidateSet("Read", "Change", "FullControl")]
		[String]$Access = "Read"
	)
	
	Process
	{
		If ((Get-WmiObject -Class "Win32_Share" -Filter "Name='$Sharename'").Name -eq $Sharename)
		{
			Try
			{
				$Tclass = [WMIClass]"\\$env:COMPUTERNAME\root\cimv2:Win32_Trustee"
				$Trustee = $TClass.CreateInstance()
				$Trustee.Domain = $ENV:USERDOMAIN
				$Trustee.Name = $User
				$aclass = [WMIClass]"\\$ENV:COMPUTERNAME\root\cimv2:Win32_ACE"
				$ACE = $AClass.CreateInstance()
				Switch ($Access)
				{
					'Read' { $ACE.AccessMask = 1179817 }
					'Change' { $ACE.AccessMask = 1245631 }
					'FullControl' { $ACE.AccessMask = 2032127 }
				}
				$ACE.AceFlags = 0
				$ACE.AceType = 0
				$ACE.Trustee = $Trustee
				$Share = Get-WmiObject -Class Win32_LogicalShareSecuritySetting -Filter "Name='$Sharename'"
				$SD = Invoke-WmiMethod -InputObject $Share -Name GetSecurityDescriptor | Select -ExpandProperty Descriptor
				$SClass = [WMIClass]"\\$ENV:COMPUTERNAME\root\cimv2:Win32_SecurityDescriptor"
				$NewSD = $SClass.CreateInstance()
				$NewSD.ControlFlags = $SD.ControlFlags
				ForEach ($ACE0 in $SD.DACL)
				{
					$NewSD.DACL += $ACE0
				}
				$NewSD.DACL += $ACE
				$Share.SetSecurityDescriptor($NewSD) | Out-Null
			}
			Catch
			{
				Show-MessageBox -Message "$_" -Title "Error" -Type Error | Out-Null
			}
		}
		Else
		{
			Show-MessageBox -Message "No existe el recurso compartido '$ShareName'!`nImposible asignar permisos." -Title "Error" -Type Error | Out-Null
		}
	}
}