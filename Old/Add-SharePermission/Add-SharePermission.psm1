<#
CSharpAndPowerShell Modules, tries to help Microsoft Windows admins to write automated scripts easier.
Copyright (C) 2015  Cristopher Robles Ríos

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
#>

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
    Script-Modules  Copyright (C) 2015  Cristopher Robles Ríos
    This program comes with ABSOLUTELY NO WARRANTY.
    This is free software, and you are welcome to redistribute it
    under certain conditions.
 
    .LINK
    https://github.com/CSharpAndPowerShell/Script-Modules
    #>
	
	#region "Parámetros"
	Param (
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName = $true, HelpMessage = "Nombre del recurso compartido existente.")]
		[String]$Sharename,
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 1, ValueFromPipelineByPropertyName = $true, HelpMessage = "Nombre del usuario o grupo al que le será compatido el recurso.")]
		[String]$User,
		[Parameter(ValueFromPipeline = $true, Position = 2, ValueFromPipelineByPropertyName = $true, HelpMessage = "Nivel de acceso que se le otorgará al usuario o grupo.")]
		[ValidateSet("Read", "Change", "FullControl")]
		[String]$Access = "Read"
	)
	#endregion
	
	#region "Funciones"
	Process
	{
		If ((Get-WmiObject -Class "Win32_Share" -Filter "Name='$Sharename'").Name -eq $Sharename)
		{
			Try
			{
				$Tclass = [WMIClass]"\\$ENV:COMPUTERNAME\root\cimv2:Win32_Trustee"
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
				Write-Error -Message "$_"
			}
		}
		Else
		{
			Write-Error -Message "No existe el recurso compartido '$ShareName'!`nImposible asignar permisos." -Category 'InvalidArgument'
		}
	}
	#endregion
}