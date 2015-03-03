#requires -RunAsAdministrator
#requires -Version 4.0
#requires -Modules New-MsgBox
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
    Escrito por Cristopher Robles
	
    .LINK
    https://github.com/PowerShellScripting
    #>
	
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
		$ObjUser = New-Object System.Security.Principal.NTAccount("$Env:USERDOMAIN\$User")
		$Args = New-Object System.Security.AccessControl.FilesystemAccessRule($ObjUser, $Rights, $InheritanceFlag, $PropagationFlag, $Type)
		$SetAcl = Get-Acl $Path
		$SetAcl.AddAccessRule($Args)
		Set-Acl $Path $SetAcl | Out-Null
	}
	Catch
	{
		New-MsgBox -Message "$_" -Title "Error" | Out-Null
	}
}