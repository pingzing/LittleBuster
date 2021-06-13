# First, run the Teal build
& tl build;

# Get source_dir and build_dir from tlconfig.lua
[string] $sourceDir = $null;
[string] $buildDir = $null;

Get-Content tlconfig.lua | ForEach-Object {
    [string] $line = $_;
    if ($line.Contains("source_dir")) {
        # Get everything to the right of the equals sign, trim away spaces and quotes
        $sourceDir = $line.Split('=')[1].Replace("`"", "").Replace("'", "").Replace(',', "").Trim();
    }
    if ($line.Contains("build_dir")) {
        $buildDir = $line.Split('=')[1].Replace("`"", "").Replace("'", "").Replace(',', "").Trim();
    }
}

# Canonicalize the paths
$sourceDir = [System.IO.Path]::Combine($PSScriptRoot, $sourceDir);
$buildDir = [System.IO.Path]::Combine($PSScriptRoot, $buildDir);

# Copy non-tl files to the output dir
Get-ChildItem $sourceDir -Recurse -File -Exclude "*.tl" | ForEach-Object {
    [System.IO.FileInfo] $file = $_;
    $destPath = $file.FullName.Replace($sourceDir, $buildDir);
    Copy-Item $file.FullName $destPath -Force;
}

# Finally, copy stuff from the root to the root output
Copy-Item .\CHANGELOG.txt $buildDir;
Copy-Item .\LittleBuster.toc $buildDir;
Copy-Item .\LICENSE.md $buildDir;