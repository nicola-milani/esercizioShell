<#
.SYNOPSIS
This script performs various operations on files and directories, including string replacement, file copying, and file modification.

.DESCRIPTION
The script contains several functions and commands to replace strings in files, copy files, and modify file contents. It follows specific instructions to perform these operations.

#>

# Set the source directory and custom source file directory
$SOURCEDIR = "content"
$CUSTOMSOURCEFILEDIR = "custom"

<#
.SYNOPSIS
Replaces all occurrences of a string in all files within a specified directory.

.DESCRIPTION
This function searches for a specified string in all files within a given directory and replaces it with a new string.

.PARAMETER STRINGA
The string to be searched for.

.PARAMETER NEWSTR
The string to replace the occurrences of the original string.

.PARAMETER DESTPATH
The destination directory where the files are located.

.EXAMPLE
replaceString -STRINGA "oldString" -NEWSTR "newString" -DESTPATH "C:\Files"
#>
function replaceString {
    param(
        [string]$STRINGA,
        [string]$NEWSTR,
        [string]$DESTPATH
    )
    
    #$files = Get-ChildItem -Path $DESTPATH -Recurse | Where-Object { $_ -is [System.IO.FileInfo] }
    #Get-ChildItem -Path $DESTPATH -Recurse | Select-String -Pattern $STRINGA -Quiet
    # Elenca tutti i file nella cartella "foldername"
    Get-ChildItem -Path "$DESTPATH" -Recurse | ForEach-Object {
        
        # Cerca la stringa "pippo" in ogni file
        $findest = Select-String -Path $_.FullName -Pattern "$STRINGA" -Quiet
        if ([System.Boolean]::Parse($findest)){
            Write-Output $_.FullName
            Write-Host $_.FullName
            (Get-Content -Path $_.FullName) -replace $STRINGA, $NEWSTR | Set-Content -Path $_.FullName
        }
        
    }
    
}

# Set the string to be replaced, destination path, and new string for replacement
$stringa = "n.iso639Code"
$destpath = "${SOURCEDIR}\lib"
$newstr = "`"it`""

# Call the replaceString function to replace the string in files within the specified directory
replaceString -STRINGA $stringa -NEWSTR $newstr -DESTPATH $destpath

$stringa = "`"en`""
$destpath = $SOURCEDIR
$newstr = "`"it`""

# Call the replaceString function again to replace the string in files within the source directory
replaceString -STRINGA $stringa -NEWSTR $newstr -DESTPATH $destpath

# Copy the custom source file to the lib directory
$SourceCustomLib = "AccessibleITA_LGT.js"
Copy-Item -Path "${CUSTOMSOURCEFILEDIR}\${SourceCustomLib}" -Destination "${SOURCEDIR}\lib"

# Add the custom library file to the dependencies in the index.html file
$IndexFilePath = "${SOURCEDIR}\index.html"

# If the custom library file is already present in the index.html file, do nothing
if (Select-String -Path $IndexFilePath -Pattern $SourceCustomLib -Quiet) {
    Write-Output "già esiste" }
else{
    $line = (Select-String -Path $IndexFilePath -Pattern "/body").LineNumber
    $NEWLINE = "
    <script type=`"text/javascript`" src=`"lib/${SourceCustomLib}`"></script>
</body>"

    $content = Get-Content -Path $IndexFilePath
    $content[$line - 1] = $NEWLINE
    $content | Set-Content -Path "$IndexFilePath"
}
