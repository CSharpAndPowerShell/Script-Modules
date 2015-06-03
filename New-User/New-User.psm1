Function New-User
{
    <#
    .SYNOPSIS
    Crear usuarios locales.
    
    .DESCRIPTION
    Esta función necesita un parámetro; "Name". Esta función verifica si el usuario existe, si no existe lo crea. El parámetro "HomeDirectory" generalmente es una carpeta compartida similar a "\\127.0.0.1\NombredeUsuario". El parámetro "HomeDirDrive" generalmente es "T:\" y en esta letra se encuentra "HomeDirectory".
 
    .EXAMPLE
    New-User -Name "P" -Description "Usuario P"
    New-User -Name "P" -Pass "Password"
    New-User "P"
 
    .NOTES
    Escrito por Cristopher Robles
	
    .LINK
    https://github.com/PowerShellScripting
    #>
	
	Param (
		[Parameter(Mandatory = $True, Position = 0, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Nombre del nuevo usuario.")]
		[ValidateNotNullOrEmpty()]
		[ValidateLength(1, 14)] #El nombre del equipo debe tener al menos un caracter y máximo 14
		[String]$Name,
		[Parameter(Position = 1, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Contraseña para el nuevo usuario.")]
		[String]$Password,
		[Parameter(Position = 2, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Descripción del nuevo usuario.")]
		[String]$Description,
		[Parameter(Position = 3, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Carpeta personal del nuevo usuario.")]
		[String]$HomeDirectory,
		[Parameter(Position = 4, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Script de inicio de sesión para el nuevo usuario.")]
		[String]$LoginScript,
		[Parameter(Position = 5, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Ruta al perfil para el nuevo usuario.")]
		[String]$Profile,
		[Parameter(Position = 6, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Letra en la que se montará el 'HomeDirectory'.")]
		[String]$HomeDirDrive,
		[Parameter(Position = 7, ValueFromPipeline = $true, ValueFromPipelineByPropertyName = $true, HelpMessage = "Grupo al que pertenecerá el nuevo usuario.")]
		[Array]$Group
	)
	
	Begin
	{
		#Objeto con la conexión de ruta donde se crearán los usuarios
		$Computer = [ADSI]"WinNT://$ENV:COMPUTERNAME"
	}
	
	Process
	{
		Try
		{
			if (!((Get-WmiObject -Class Win32_Account -Filter "Name='$Name'").Name -eq "$Name"))
			{
				#Se valida si el usuario existe
				#Objeto que llamará metodos del API para asignar del usuario para luego crearlo
				$User = $Computer.Create("user", $Name) #Se establece el nombre completo para el usuario
				$User.Put("Fullname", $Name)
				If ($Pass.Length -ne 0)
				{
					#Comprueba si el usuario se creará con contraseña
					$User.SetPassword($Pass)
				}
				$User.SetInfo() #Se crea el usuario con los valores anteriores
				If ($Description.Length -ne 0)
				{
					#Se asigna descripción del usuario
					$User.Description = $Description
				}
				If ($HomeDirectory.Length -ne 0)
				{
					#Comprueba si se ha asignado una carpeta particular al usuario
					#Se asigna carpeta particular al usuario
					$User.Put("HomeDirectory", $HomeDirectory)
				}
				If ($LoginScript.Length -ne 0)
				{
					#Comprueba si se ha asignado un script de inicio de sesión al usuario
					#Se asigna script de inicio de sesión al usuario
					$User.Put("LoginScript", $LoginScript)
				}
				If ($Profile.Length -ne 0)
				{
					#Comprueba si se ha asignado un perfil mandatorio al usuario
					$User.Put("Profile", $Profile)
				}
				If ($HomeDirDrive.Length -ne 0)
				{
					#Comprueba si se ha asignado una unidad en red al usuario
					$User.Put("HomeDirDrive", $HomeDirDrive)
				}
				#El usuario no puede cambiar contraseña y contraseña no caduca
				$User.UserFlags = 64 + 65536
				#Se aplican los cambios al usuario
				$User.SetInfo()
			}
            If ($Group -ne $null)
            {
				#Si el usuario ya existe, Se agrega el usuario al grupo local
                Add-ToGroup -Name $Name -Group $Group
            }
		}
		Catch
		{
			Write-Error -Message "$_" -Category InvalidResult
		}
	}
}