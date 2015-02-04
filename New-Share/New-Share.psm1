﻿#requires -RunAsAdministrator
#requires -Modules New-ACE, Add-SharePermissions, New-MsgBox
#requires -Version 4.0
Function New-Share {
    <#
    .SYNOPSIS
    Crear recursos compartidos, en equipos y servidores.
    
    .DESCRIPTION
    Esta función necesita de todos sus parámetros a excepción de "Description". Esta función verifica si el recurso compartido existe, si no existe lo crea.
    El parámetro "Access" permite únicamente los siguientes modificadores:
        FullControl - acceso total
        Change - permiso de cambiar
        Read - sólo lectura
 
    .EXAMPLE
    New-Share -User "A" -Sharename "A Share" -Path "D:\Producción\Carpeta A" -Access "FullControl"
    New-Share -User "B" -Sharename "B Share" -Path "D:\Producción\Carpeta B" -Access "Read"
 
    .NOTES
    Escrito por Cristopher Robles
	
    .LINK
    https://github.com/PowerShellScripting
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true,Position=0,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Nombre del nuevo recurso compartido.")]
        [ValidateNotNullOrEmpty()]
        [String]$Sharename,
        [Parameter(Mandatory=$true,Position=1,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Ruta a la carpeta a compartir.")]
        [ValidateNotNullOrEmpty()]
        [String]$Path,
        [Parameter(Mandatory=$true,Position=2,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Nombre del usuario o grupo al que le será compatido el recurso.")]
        [ValidateNotNullOrEmpty()]
        [String]$User,
        [Parameter(Position=3,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true,HelpMessage="Nivel de acceso que se le otorgará al usuario o grupo.")]
        [ValidateSet("FullControl","Change","Read")]
        [String]$Access="Read",
        [Parameter(ValueFromPipeline=$true,Position=4,ValueFromPipelineByPropertyName=$true,HelpMessage="Nivel de acceso que se le otorgará al usuario o grupo.")]
        [ValidateSet("ListDirectory","ReadData","WriteData","CreateFiles","CreateDirectories","AppendData","ReadExtendedAttributes","WriteExtendedAttributes","Traverse","ExecuteFile","DeleteSubdirectoriesAndFiles","ReadAttributes","WriteAttributes","Write","Delete","ReadPermissions","Read","ReadAndExecute","Modify","ChangePermissions","TakeOwnership","Synchronize","FullControl")]
        [string]$Right,
        [Parameter(ValueFromPipeline=$true,Position=5,ValueFromPipelineByPropertyName=$true,HelpMessage="Tipo de ACL que se le otorgará al usuario o grupo.")]
        [ValidateSet("Allow", "Deny")]
        [string]$ACL = "Allow",
        [Parameter(Position=6,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
	    [String]$Description
    )
	
    Process {
		Try {
	        If (!(test-path $Path)) {
	            New-Item $Path -type Directory -Force | Out-Null
	        }
	        If (!(Get-WmiObject -Class "Win32_Share").Name.Contains($Sharename)) {
			    $Shares=[WMICLASS]"WIN32_Share"
	            If ($Description.Length -ne 0) {
		            $Shares.Create($Path,$Sharename,0,$Description) | Out-Null
	            }
	            Else {
	                $Shares.Create($Path,$Sharename,0) | Out-Null
	            }
	        }
	        If (($Right -eq $null) -or ($Right -eq "")) { #Agregando permisos ACL, visibles en pestaña seguridad (Esta Carpeta, Subcarpetas y Archivos : Asigancion por defecto)
	            If ($Access -eq "Change") { #Se hace el cambio porque New-ACE no soporta el modificador "Change"
	                $Right = "Write"
	            }
	            Else {
	                $Right = $Access
	            }
	        }
			#Agregando permisos al recurso compartido
	        New-ACE -Path $Path -User $User -Right $Right -ACL $ACL
	        Add-SharePermission -Sharename $Sharename -User $User -Access $Access
		}
		Catch {
			New-MsgBox -Message "$_" -Title "Error" | Out-Null
		}
    }
}

Export-ModuleMember New-Share