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

Function New-ACE
{
    <#
    .SYNOPSIS
    Asigna permisos NTFS a carpetas y archivos.
	
    .DESCRIPTION
    El sistema de archivos NTFS permite el uso de permisos avanzados para archivos y carpetas, ya sea para recursos en red o locales.
	
    .EXAMPLE
    New-Ace -Path 'C:\crisrc012' -Right "Write" -User "Usuario"
	
    .NOTES
    Script-Modules  Copyright (C) 2015  Cristopher Robles Ríos
    This program comes with ABSOLUTELY NO WARRANTY.
    This is free software, and you are welcome to redistribute it
    under certain conditions.
	
    .LINK
    https://github.com/CSharpAndPowerShell/Script-Modules
    #>
	
	#region "Parametros"
	Param (
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 0, ValueFromPipelineByPropertyName = $true, HelpMessage = "Ruta del archivo o carpeta a cambiar permisos.")]
		[string]$Path,
		[Parameter(Mandatory = $true, ValueFromPipeline = $true, Position = 1, ValueFromPipelineByPropertyName = $true, HelpMessage = "Nombre del usuario o grupo al que se le modificará el acceso.")]
		[string]$User,
		[Parameter(ValueFromPipeline = $true, Position = 2, ValueFromPipelineByPropertyName = $true, HelpMessage = "Nivel de acceso que se le otorgará al usuario o grupo.")]
		[ValidateSet("ListDirectory", "ReadData", "WriteData", "CreateFiles", "CreateDirectories", "AppendData", "ReadExtendedAttributes", "WriteExtendedAttributes", "Traverse", "ExecuteFile", "DeleteSubdirectoriesAndFiles", "ReadAttributes", "WriteAttributes", "Write", "Delete", "ReadPermissions", "Read", "ReadAndExecute", "Modify", "ChangePermissions", "TakeOwnership", "Synchronize", "FullControl")]
		[string]$Right = "Read",
		[Parameter(ValueFromPipeline = $true, Position = 3, ValueFromPipelineByPropertyName = $true, HelpMessage = "Tipo de ACL que se le otorgará al usuario o grupo.")]
		[ValidateSet("Allow", "Deny")]
		[string]$ACL = "Allow"
	)
	#endregion
	
	#region "Funciones"
	Process
	{
		Try
		{
			If (!(Test-Path $Path))
			{
				mkdir $Path -Force | Out-Null
			}
			$Rights = [System.Security.AccessControl.FileSystemRights]$Right
			$InheritanceFlag = [System.Security.AccessControl.InheritanceFlags]::ContainerInherit `
			-bor [System.Security.AccessControl.InheritanceFlags]::ObjectInherit
			$PropagationFlag = [System.Security.AccessControl.PropagationFlags]::None
			$Type = [System.Security.AccessControl.AccessControlType]::$ACL
			$ObjUser = New-Object System.Security.Principal.NTAccount("$ENV:USERDOMAIN\$User")
			$Args = New-Object System.Security.AccessControl.FilesystemAccessRule($ObjUser, $Rights, $InheritanceFlag, $PropagationFlag, $Type)
			$SetAcl = Get-Acl $Path
			$SetAcl.AddAccessRule($Args)
			Set-Acl $Path $SetAcl | Out-Null
		}
		Catch
		{
			Write-Error -Message "$_" -Category 'PermissionDenied'
		}
	}
	#endregion
}