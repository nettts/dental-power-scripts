# set the path to the root directory where the INI files are located
$root_dir = "Letter:\path\to\root\folder"

# set the path to the output directory
$output_dir = "Letter:\path\to\output\folder"

# define a function to recursively read the INI files
function Read-IniFiles($directory) {
    $files = Get-ChildItem -Path $directory -Recurse -Filter "FILEDATA.TXT"

    foreach ($file in $files) {
        # read the contents of the INI file
        $config = Get-Content -Path $file.FullName | Select -Skip 1 | ConvertFrom-StringData

        # create the output directory based on the NOM and PRENOM variables
        $nom = $config.NOM
        $prenom = $config.PRENOM
        $output_subdir = Join-Path $output_dir "$($nom)_$($prenom)"
        New-Item -ItemType Directory -Path $output_subdir -Force | Out-Null

        # copy all content into the target folder where the INI file resided
        Copy-Item -Path $file.DirectoryName -Destination $output_subdir -Recurse -Force
    }

    $subdirs = Get-ChildItem -Path $directory -Directory

    foreach ($subdir in $subdirs) {
        Read-IniFiles $subdir.FullName
    }
}

# start the recursive read process
Read-IniFiles $root_dir