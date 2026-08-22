param(
    [string]$ModsPath = ".\mods",
    [string]$ManifestPath = ".\MOD_MANIFEST.csv",
    [string]$ChangesPath = ".\MOD_CHANGES.md",
    [string]$MinecraftVersion = "1.21.1"
)

$ErrorActionPreference = "Stop"

Add-Type -AssemblyName System.IO.Compression.FileSystem

# ============================================================
# ZIP / METADATA HELPERS
# ============================================================

function Read-ZipEntryText {
    param(
        [System.IO.Compression.ZipArchive]$Zip,
        [string[]]$Candidates
    )

    foreach ($Candidate in $Candidates) {
        $Entry = $Zip.Entries |
            Where-Object { $_.FullName -ieq $Candidate } |
            Select-Object -First 1

        if ($Entry) {
            $Reader = New-Object System.IO.StreamReader($Entry.Open())

            try {
                return [PSCustomObject]@{
                    Path = $Entry.FullName
                    Text = $Reader.ReadToEnd()
                }
            }
            finally {
                $Reader.Dispose()
            }
        }
    }

    return $null
}

function ConvertFrom-JarManifest {
    param([string]$Text)

    $Attributes = @{}
    $CurrentKey = $null

    foreach ($Line in ($Text -split "`r?`n")) {
        # JAR manifest continuation lines begin with one leading space.
        if ($Line -match '^\s' -and $CurrentKey) {
            $Attributes[$CurrentKey] += $Line.Substring(1)
            continue
        }

        if ($Line -match '^([^:]+):\s?(.*)$') {
            $CurrentKey = $Matches[1].Trim()
            $Attributes[$CurrentKey] = $Matches[2].Trim()
        }
        else {
            $CurrentKey = $null
        }
    }

    return $Attributes
}

function Get-FirstValue {
    param(
        [hashtable]$Table,
        [string[]]$Keys
    )

    foreach ($Key in $Keys) {
        if ($Table.ContainsKey($Key)) {
            $Value = [string]$Table[$Key]

            if (-not [string]::IsNullOrWhiteSpace($Value)) {
                return $Value.Trim()
            }
        }
    }

    return $null
}

function Get-TomlValue {
    param(
        [string]$Block,
        [string]$Key
    )

    $EscapedKey = [regex]::Escape($Key)

    # Accepts:
    # key = "value"
    # key = 'value'
    # key = bareValue
    $Pattern = '(?mi)^\s*{0}\s*=\s*(?:"([^"]*)"|''([^'']*)''|([^\s#]+))' -f $EscapedKey
    $Match = [regex]::Match($Block, $Pattern)

    if (-not $Match.Success) {
        return $null
    }

    foreach ($Index in 1..3) {
        if ($Match.Groups[$Index].Success) {
            return $Match.Groups[$Index].Value.Trim()
        }
    }

    return $null
}

function Get-TomlModBlocks {
    param([string]$Text)

    return @(
        [regex]::Matches(
            $Text,
            '(?ms)^\s*\[\[mods\]\]\s*(.*?)(?=^\s*\[\[|\z)'
        )
    )
}

function ConvertTo-StableId {
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return $null
    }

    # Stable machine IDs should be boring and predictable.
    # Do not try to infer CamelCase word boundaries here.
    $Id = $Value.Trim()
    $Id = $Id -replace '\[[^\]]+\]', ''
    $Id = $Id.ToLowerInvariant()
    $Id = $Id -replace '[^a-z0-9]+', '_'
    $Id = $Id.Trim('_')

    if ([string]::IsNullOrWhiteSpace($Id)) {
        return $null
    }

    return $Id
}

function ConvertTo-DisplayName {
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return $null
    }

    $Name = $Value.Trim()
    $Name = $Name -replace '\[[^\]]+\]', ' '

    # PowerShell -replace is case-insensitive by default.
    # Use -creplace here so CamelCase splitting only reacts to actual capitals.
    $Name = $Name -creplace '([A-Z]+)([A-Z][a-z])', '$1 $2'
    $Name = $Name -creplace '([a-z0-9])([A-Z])', '$1 $2'

    $Name = $Name -replace '[_-]+', ' '
    $Name = $Name -replace '\s+', ' '

    return $Name.Trim()
}

function Get-FilenameIdentity {
    param([string]$FileName)

    $Stem = [System.IO.Path]::GetFileNameWithoutExtension($FileName).Trim()
    $Working = $Stem

    # Strip bracketed loader labels such as "[NeoForge]".
    $Working = ($Working -replace '\s*\[[^\]]+\]\s*', ' ').Trim()

    # Strip packaging / loader suffixes that are not the mod version.
    do {
        $Before = $Working

        $Working = $Working -replace `
            '(?i)(?:[-_. ]+)(?:all|universal|neoforge|forge|fabric|quilt|release)$', `
            ''

        $Working = $Working.Trim(' ', '-', '_', '.')
    }
    while ($Working -ne $Before)

    $Version = $null
    $Base = $Working

    # Extract a final numeric version token.
    #
    # Examples:
    # Foo-1.21.1-2.0.3  -> version 2.0.3, base Foo-1.21.1
    # Foo-v2            -> version 2, base Foo
    # Foo-5.12.0-all    -> version 5.12.0 after suffix cleanup
    $VersionPattern = '(?i)(?:^|[-_ ])v?(?<version>\d+(?:\.\d+){0,4}[A-Za-z]?(?:[-+][0-9A-Za-z][0-9A-Za-z._+-]*)?)$'
    $VersionMatch = [regex]::Match($Working, $VersionPattern)

    if ($VersionMatch.Success) {
        $Version = $VersionMatch.Groups['version'].Value
        $Base = $Working.Substring(0, $VersionMatch.Index).Trim(' ', '-', '_', '.')

        # If the remaining final token is clearly a Minecraft version,
        # remove it from the fallback identity.
        $MinecraftPattern = '(?i)(?<prefix>.*?)(?:[-_ ])(?:mc)?(?<mc>1\.\d+(?:\.\d+)?)$'
        $MinecraftMatch = [regex]::Match($Base, $MinecraftPattern)

        if (
            $MinecraftMatch.Success -and
            -not [string]::IsNullOrWhiteSpace($MinecraftMatch.Groups['prefix'].Value)
        ) {
            $Base = $MinecraftMatch.Groups['prefix'].Value.Trim(' ', '-', '_', '.')
        }
    }

    if ([string]::IsNullOrWhiteSpace($Base)) {
        $Base = $Stem
    }

    return [PSCustomObject]@{
        Id      = ConvertTo-StableId $Base
        Name    = ConvertTo-DisplayName $Base
        Version = $Version
    }
}

function Convert-PackDescriptionToText {
    param($Description)

    if ($null -eq $Description) {
        return $null
    }

    if ($Description -is [string]) {
        $Text = [string]$Description
        $Text = $Text -replace '§[0-9A-FK-ORa-fk-or]', ''
        $Text = $Text.Trim()

        if (-not [string]::IsNullOrWhiteSpace($Text)) {
            return $Text
        }

        return $null
    }

    if (
        $Description -is [System.Collections.IEnumerable] -and
        -not ($Description -is [pscustomobject])
    ) {
        $Parts = @(
            foreach ($Part in $Description) {
                $PartText = Convert-PackDescriptionToText $Part

                if (-not [string]::IsNullOrWhiteSpace($PartText)) {
                    $PartText
                }
            }
        )

        if ($Parts.Count -gt 0) {
            return (($Parts -join ' ') -replace '\s+', ' ').Trim()
        }

        return $null
    }

    if ($Description.PSObject.Properties.Name -contains 'text') {
        $Text = Convert-PackDescriptionToText $Description.text

        if (-not [string]::IsNullOrWhiteSpace($Text)) {
            return $Text
        }
    }

    if ($Description.PSObject.Properties.Name -contains 'extra') {
        $Extra = Convert-PackDescriptionToText $Description.extra

        if (-not [string]::IsNullOrWhiteSpace($Extra)) {
            return $Extra
        }
    }

    return $null
}


function Normalize-VersionSeparators {
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return $null
    }

    $Text = $Value.Trim()

    do {
        $Before = $Text

        $Text = $Text -replace '-{2,}', '-'
        $Text = $Text -replace '\+{2,}', '+'
        $Text = $Text -replace '\+-', '+'
        $Text = $Text -replace '-\+', '+'
        $Text = $Text -replace '\s{2,}', ' '

        $Text = $Text.Trim(' ', '-', '+', '_', '.')
    }
    while ($Text -ne $Before)

    if ([string]::IsNullOrWhiteSpace($Text)) {
        return $null
    }

    return $Text
}

function Test-HasIndependentVersionToken {
    param([string]$Value)

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return $false
    }

    # The boundaries deliberately reject digits embedded in mod names such as
    # AE2 or Create6, but accept real standalone versions such as:
    #   93
    #   v2
    #   1.2.0
    #   0.4.0-alpha.0.116
    return [regex]::IsMatch(
        $Value,
        '(?i)(?<![A-Za-z0-9])v?\d+(?:\.\d+)*[A-Za-z]?(?:[-+][0-9A-Za-z][0-9A-Za-z._+-]*)?(?![A-Za-z0-9])'
    )
}

function Remove-VersionCompatibilityTokens {
    param(
        [string]$Value,
        [string]$MinecraftVersion
    )

    if ([string]::IsNullOrWhiteSpace($Value)) {
        return $null
    }

    $Working = $Value.Trim()

    # Minecraft compatibility tokens are removed only when another independent
    # version token remains. This prevents an edge case where a mod genuinely
    # declares its own version as exactly "1.21.1".
    #
    # For a 1.21.1 pack this recognizes the whole 1.21 family when it appears
    # as a compatibility token:
    #   1.21
    #   1.21.x
    #   1.21.0
    #   1.21.1
    #   1.21.4
    #   mc1.21.1
    #   mc.1.21.1
    #   nf1.21.1
    #
    # It will NOT strip a longer real version such as 1.21.0.6 because the
    # compatibility token must end at a non-numeric/non-dot boundary.
    if (-not [string]::IsNullOrWhiteSpace($MinecraftVersion)) {
        $Parts = $MinecraftVersion -split '\.'

        if ($Parts.Count -ge 2) {
            $MajorMinor = "$($Parts[0]).$($Parts[1])"
            $EscapedMajorMinor = [regex]::Escape($MajorMinor)

            $MinecraftPattern = `
                "(?i)(?<![\d.])(?:mc(?:[._-])?|minecraft(?:[._-])?|nf(?:[._-])?)?$EscapedMajorMinor(?:\.(?:\d+|x))?(?![\d.])"

            do {
                $RemovedMinecraftToken = $false
                $Matches = [regex]::Matches($Working, $MinecraftPattern)

                foreach ($Match in $Matches) {
                    $Candidate = (
                        $Working.Substring(0, $Match.Index) +
                        $Working.Substring($Match.Index + $Match.Length)
                    )

                    $Candidate = Normalize-VersionSeparators $Candidate

                    if (
                        -not [string]::IsNullOrWhiteSpace($Candidate) -and
                        (Test-HasIndependentVersionToken $Candidate)
                    ) {
                        $Working = $Candidate
                        $RemovedMinecraftToken = $true
                        break
                    }
                }
            }
            while ($RemovedMinecraftToken)
        }
    }

    # Strip loader/packaging words when they are standalone components.
    # This handles forms such as:
    #   1.2.0-neoforge-1.21.1
    #   1.21.1-NeoForge-3.1.4
    #   1.2.1+neoforge-create6-1.21.1
    $LoaderPattern = `
        '(?i)(^|[-+_. ])(?:neoforge|forge|fabric|quilt|universal|all|release)(?=$|[-+_. ])'

    do {
        $Before = $Working
        $Working = [regex]::Replace($Working, $LoaderPattern, '$1')
        $Working = Normalize-VersionSeparators $Working
    }
    while ($Working -ne $Before)

    if ([string]::IsNullOrWhiteSpace($Working)) {
        return $null
    }

    # Clean malformed trailing punctuation seen in a few mod metadata versions,
    # for example "2.1.4.".
    $Working = $Working -replace '[._+-]+$', ''
    $Working = Normalize-VersionSeparators $Working

    return $Working
}

function Get-VersionCanonical {
    param(
        [string]$Value,
        [string]$MinecraftVersion
    )

    $Clean = Remove-VersionCompatibilityTokens `
        -Value $Value `
        -MinecraftVersion $MinecraftVersion

    if ([string]::IsNullOrWhiteSpace($Clean)) {
        return $null
    }

    $Clean = $Clean.Trim()

    if ($Clean.StartsWith('v', [System.StringComparison]::OrdinalIgnoreCase)) {
        $Clean = $Clean.Substring(1)
    }

    return $Clean.Trim(' ', '-', '+', '_', '.').ToLowerInvariant()
}

function Get-VersionCandidateScore {
    param(
        [string]$Candidate,
        [string]$MetadataVersion,
        [string]$MinecraftVersion
    )

    if (
        [string]::IsNullOrWhiteSpace($Candidate) -or
        [string]::IsNullOrWhiteSpace($MetadataVersion)
    ) {
        return 0
    }

    $CandidateCanonical = Get-VersionCanonical `
        -Value $Candidate `
        -MinecraftVersion $MinecraftVersion

    $MetadataCanonical = Get-VersionCanonical `
        -Value $MetadataVersion `
        -MinecraftVersion $MinecraftVersion

    if (
        [string]::IsNullOrWhiteSpace($CandidateCanonical) -or
        [string]::IsNullOrWhiteSpace($MetadataCanonical)
    ) {
        return 0
    }

    if ($CandidateCanonical -eq $MetadataCanonical) {
        return 1000
    }

    # Filename versions are often a more specific artifact revision of the
    # embedded metadata version:
    #   metadata 1.5.85      -> file 1.5.85.2077
    #   metadata 1.11.7      -> file 1.11.7b
    #   metadata 2.1.4       -> file v2.1.4a
    if (
        $CandidateCanonical.StartsWith($MetadataCanonical) -and
        $CandidateCanonical.Length -gt $MetadataCanonical.Length
    ) {
        $NextCharacter = $CandidateCanonical[$MetadataCanonical.Length]

        # Require a real version boundary. Without this guard, metadata "1.2"
        # would incorrectly be treated as a prefix of Minecraft "1.21.1".
        if ($NextCharacter -match '[A-Za-z._+-]') {
            return 900
        }
    }

    if (
        $CandidateCanonical.EndsWith($MetadataCanonical) -and
        $CandidateCanonical.Length -gt $MetadataCanonical.Length
    ) {
        $PrefixLength = $CandidateCanonical.Length - $MetadataCanonical.Length
        $PreviousCharacter = $CandidateCanonical[$PrefixLength - 1]

        if ($PreviousCharacter -match '[-+._]') {
            return 850
        }
    }

    if (
        $MetadataCanonical.StartsWith($CandidateCanonical) -and
        $MetadataCanonical.Length -gt $CandidateCanonical.Length
    ) {
        $NextCharacter = $MetadataCanonical[$CandidateCanonical.Length]

        if ($NextCharacter -match '[A-Za-z._+-]') {
            return 800
        }
    }

    # Handle stale embedded metadata where the artifact filename clearly moved
    # within the same release family, for example Incendium 5.4.3 metadata in
    # a v5.4.4 JAR, or a Create addon changing 2.2.1 -> 2.2.2 while retaining
    # a second compatibility/build component.
    $CandidateCoreMatch = [regex]::Match(
        $CandidateCanonical,
        '^\d+(?:\.\d+)+'
    )

    $MetadataCoreMatch = [regex]::Match(
        $MetadataCanonical,
        '^\d+(?:\.\d+)+'
    )

    if ($CandidateCoreMatch.Success -and $MetadataCoreMatch.Success) {
        $CandidateParts = $CandidateCoreMatch.Value -split '\.'
        $MetadataParts = $MetadataCoreMatch.Value -split '\.'

        $CommonPrefix = 0
        $Limit = [Math]::Min($CandidateParts.Count, $MetadataParts.Count)

        for ($Index = 0; $Index -lt $Limit; $Index++) {
            if ($CandidateParts[$Index] -ne $MetadataParts[$Index]) {
                break
            }

            $CommonPrefix++
        }

        if ($CommonPrefix -ge 2) {
            return (650 + ($CommonPrefix * 25))
        }

        if ($CommonPrefix -eq 1) {
            return 350
        }
    }

    return 0
}

function Get-FileVersionToken {
    param(
        [string]$FileName,
        [string]$MinecraftVersion,
        [string]$MetadataVersion
    )

    if ([string]::IsNullOrWhiteSpace($FileName)) {
        return $null
    }

    $Working = [System.IO.Path]::GetFileNameWithoutExtension($FileName).Trim()

    # Remove bracketed loader labels such as "[NeoForge]".
    $Working = (
        $Working -replace `
            '\s*\[(?i:neoforge|forge|fabric|quilt)\]\s*$', `
            ''
    ).Trim()

    # Remove Minecraft compatibility and loader tokens from anywhere in the
    # filename, not only at the end. This is what fixes names such as:
    #   Aquaculture-1.21.1-2.7.21.jar
    #   cfm_wap-1.21.1-neoforge-1.2.0.jar
    #   deimos-1.21.1-neoforge-2.7.jar
    #   create-stuff-additions1.21.1_v2.1.4a.jar
    #   twilight_forest_final_boss-2.1.0+4.7.3196+1.21.1.jar
    $Working = Remove-VersionCompatibilityTokens `
        -Value $Working `
        -MinecraftVersion $MinecraftVersion

    if ([string]::IsNullOrWhiteSpace($Working)) {
        return $null
    }

    $CleanMetadataVersion = Remove-VersionCompatibilityTokens `
        -Value $MetadataVersion `
        -MinecraftVersion $MinecraftVersion

    # Build every possible VERSION-TO-END candidate rather than trusting the
    # first numeric token. This handles filenames with several numeric fields:
    #
    #   Almanac-1.21.1-2-neoforge-1.5.2
    #       candidates: 2-1.5.2, 1.5.2
    #       metadata anchor selects 1.5.2
    #
    #   create_mechanical_extruder-1.21.1-2.2.2-6.0.10
    #       candidates: 2.2.2-6.0.10, 6.0.10
    #       metadata similarity selects 2.2.2-6.0.10
    #
    #   CrashAssistant-neoforge-1.20.6-1.21.4-1.11.11
    #       metadata anchor selects 1.11.11
    $Starts = [System.Collections.Generic.HashSet[int]]::new()
    [void]$Starts.Add(0)

    foreach ($Match in [regex]::Matches($Working, '(?i)[-_ ](?=v?\d)')) {
        [void]$Starts.Add($Match.Index + $Match.Length)
    }

    $VersionPattern = `
        '(?i)^v?\d+(?:\.\d+){0,6}[A-Za-z]?(?:[-+][0-9A-Za-z][0-9A-Za-z._+-]*)?$'

    $Candidates = @(
        foreach ($Start in ($Starts | Sort-Object)) {
            if ($Start -ge $Working.Length) {
                continue
            }

            $Candidate = $Working.Substring($Start).Trim(' ', '-', '_')

            if ([regex]::IsMatch($Candidate, $VersionPattern)) {
                $Candidate
            }
        }
    )

    if ($Candidates.Count -eq 0) {
        return $null
    }

    if (-not [string]::IsNullOrWhiteSpace($CleanMetadataVersion)) {
        $BestCandidate = $null
        $BestScore = -1

        foreach ($Candidate in $Candidates) {
            $Score = Get-VersionCandidateScore `
                -Candidate $Candidate `
                -MetadataVersion $CleanMetadataVersion `
                -MinecraftVersion $MinecraftVersion

            # >= keeps the later/more-specific candidate on a score tie.
            if ($Score -ge $BestScore) {
                $BestScore = $Score
                $BestCandidate = $Candidate
            }
        }

        # Require at least two matching numeric release components (or one of
        # the stronger exact/prefix relationships above). A mere shared major
        # version is not enough. This prevents an MC-only filename such as
        # "Dungeons ... 1.21.1.jar" from overriding metadata version 1.2.
        if ($BestScore -ge 600) {
            return $BestCandidate
        }

        return $null
    }

    # Metadata-less fallback: the last valid version-to-end candidate is the
    # least likely to be a number embedded in the mod name.
    return $Candidates[-1]
}

function Get-ReportVersion {
    param(
        $Mod,
        [string]$MinecraftVersion
    )

    if ($null -eq $Mod) {
        return 'UNKNOWN'
    }

    $MetadataVersion = Remove-VersionCompatibilityTokens `
        -Value ([string]$Mod.Version) `
        -MinecraftVersion $MinecraftVersion

    $FileVersion = $null

    if (-not [string]::IsNullOrWhiteSpace([string]$Mod.Jar)) {
        $FileVersion = Get-FileVersionToken `
            -FileName ([string]$Mod.Jar) `
            -MinecraftVersion $MinecraftVersion `
            -MetadataVersion ([string]$Mod.Version)
    }

    if (-not [string]::IsNullOrWhiteSpace($FileVersion)) {
        return $FileVersion
    }

    if (-not [string]::IsNullOrWhiteSpace($MetadataVersion)) {
        return $MetadataVersion
    }

    if (-not [string]::IsNullOrWhiteSpace([string]$Mod.Version)) {
        return [string]$Mod.Version
    }

    return 'UNKNOWN'
}

function Get-PackMetadata {
    param([System.IO.Compression.ZipArchive]$Zip)

    $PackEntry = Read-ZipEntryText $Zip @('pack.mcmeta')

    if (-not $PackEntry) {
        return $null
    }

    $Description = $null

    try {
        $PackJson = $PackEntry.Text | ConvertFrom-Json

        if ($PackJson.pack) {
            $Description = Convert-PackDescriptionToText $PackJson.pack.description
        }
    }
    catch {
        # A malformed or nonstandard pack.mcmeta should not abort the manifest.
    }

    return [PSCustomObject]@{
        Path        = $PackEntry.Path
        Description = $Description
    }
}

function Get-JarNamespaces {
    param([System.IO.Compression.ZipArchive]$Zip)

    $Namespaces = [System.Collections.Generic.HashSet[string]]::new(
        [System.StringComparer]::OrdinalIgnoreCase
    )

    foreach ($Entry in $Zip.Entries) {
        if ($Entry.FullName -match '^(?:data|assets)/([^/]+)/') {
            [void]$Namespaces.Add($Matches[1])
        }
    }

    return @($Namespaces | Sort-Object)
}

function Resolve-VersionPlaceholder {
    param(
        [string]$Version,
        [hashtable]$ManifestAttributes
    )

    if (
        [string]::IsNullOrWhiteSpace($Version) -or
        $Version -match '^\$\{.+\}$'
    ) {
        return Get-FirstValue $ManifestAttributes @(
            'Implementation-Version',
            'Specification-Version',
            'Bundle-Version'
        )
    }

    return $Version
}

# ============================================================
# JAR IDENTIFICATION
# ============================================================

function Get-ModInfo {
    param([System.IO.FileInfo]$File)

    $Zip = $null

    try {
        $Zip = [System.IO.Compression.ZipFile]::OpenRead($File.FullName)

        $Hash = (Get-FileHash -LiteralPath $File.FullName -Algorithm SHA256).Hash
        $Namespaces = @(Get-JarNamespaces $Zip)
        $FilenameIdentity = Get-FilenameIdentity $File.Name
        $PackMetadata = Get-PackMetadata $Zip

        # --------------------------------------------------------
        # Read JAR manifest once
        # --------------------------------------------------------

        $ManifestEntry = Read-ZipEntryText $Zip @('META-INF/MANIFEST.MF')
        $ManifestAttributes = @{}

        if ($ManifestEntry) {
            $ManifestAttributes = ConvertFrom-JarManifest $ManifestEntry.Text
        }

        $ManifestVersion = Get-FirstValue $ManifestAttributes @(
            'Implementation-Version',
            'Specification-Version',
            'Bundle-Version'
        )

        $ManifestTitle = Get-FirstValue $ManifestAttributes @(
            'Implementation-Title',
            'Specification-Title',
            'Bundle-Name'
        )

        $AutomaticModuleName = Get-FirstValue $ManifestAttributes @(
            'Automatic-Module-Name'
        )

        # --------------------------------------------------------
        # 1. NeoForge / Forge TOML
        # --------------------------------------------------------

        $TomlEntry = Read-ZipEntryText $Zip @(
            'META-INF/neoforge.mods.toml',
            'META-INF/mods.toml'
        )

        if ($TomlEntry) {
            $Blocks = @(Get-TomlModBlocks $TomlEntry.Text)

            if ($Blocks.Count -gt 0) {
                $AllModIds = [System.Collections.Generic.List[string]]::new()

                foreach ($BlockMatch in $Blocks) {
                    $Block = $BlockMatch.Groups[1].Value
                    $BlockModId = Get-TomlValue $Block 'modId'

                    if ($BlockModId -and $BlockModId -notin $AllModIds) {
                        [void]$AllModIds.Add($BlockModId)
                    }
                }

                $PrimaryBlock = $Blocks[0].Groups[1].Value
                $PrimaryModId = Get-TomlValue $PrimaryBlock 'modId'
                $DisplayName = Get-TomlValue $PrimaryBlock 'displayName'

                $Version = Resolve-VersionPlaceholder `
                    (Get-TomlValue $PrimaryBlock 'version') `
                    $ManifestAttributes

                if ([string]::IsNullOrWhiteSpace($PrimaryModId)) {
                    $PrimaryModId = $FilenameIdentity.Id
                }

                if ([string]::IsNullOrWhiteSpace($DisplayName)) {
                    $DisplayName = $ManifestTitle
                }

                if ([string]::IsNullOrWhiteSpace($DisplayName)) {
                    $DisplayName = $PrimaryModId
                }

                if ([string]::IsNullOrWhiteSpace($Version)) {
                    $Version = $FilenameIdentity.Version
                }

                if ([string]::IsNullOrWhiteSpace($Version)) {
                    $Version = 'UNKNOWN'
                }

                if ($PrimaryModId -and $PrimaryModId -notin $AllModIds) {
                    [void]$AllModIds.Insert(0, $PrimaryModId)
                }

                return [PSCustomObject]@{
                    ModId          = $PrimaryModId
                    Name           = $DisplayName
                    Version        = $Version
                    Jar            = $File.Name
                    AllModIds      = ($AllModIds -join ';')
                    SHA256         = $Hash
                    MetadataPath   = $TomlEntry.Path
                    MetadataSource = 'NeoForge/Forge TOML'
                    Confidence     = 'HIGH'
                    Namespaces     = ($Namespaces -join ';')
                }
            }
        }

        # --------------------------------------------------------
        # 2. Fabric metadata
        # --------------------------------------------------------

        $FabricEntry = Read-ZipEntryText $Zip @('fabric.mod.json')

        if ($FabricEntry) {
            try {
                $Fabric = $FabricEntry.Text | ConvertFrom-Json
                $PrimaryModId = [string]$Fabric.id

                if (-not [string]::IsNullOrWhiteSpace($PrimaryModId)) {
                    $DisplayName = [string]$Fabric.name
                    $Version = [string]$Fabric.version

                    if ([string]::IsNullOrWhiteSpace($DisplayName)) {
                        $DisplayName = $ManifestTitle
                    }

                    if (
                        [string]::IsNullOrWhiteSpace($DisplayName) -and
                        $PackMetadata -and
                        -not [string]::IsNullOrWhiteSpace($PackMetadata.Description)
                    ) {
                        $DisplayName = $PackMetadata.Description
                    }

                    if ([string]::IsNullOrWhiteSpace($DisplayName)) {
                        $DisplayName = $PrimaryModId
                    }

                    if (
                        [string]::IsNullOrWhiteSpace($Version) -or
                        $Version -match '^\$\{.+\}$'
                    ) {
                        $Version = $ManifestVersion
                    }

                    if ([string]::IsNullOrWhiteSpace($Version)) {
                        $Version = $FilenameIdentity.Version
                    }

                    if ([string]::IsNullOrWhiteSpace($Version)) {
                        $Version = 'UNKNOWN'
                    }

                    $AllModIds = [System.Collections.Generic.List[string]]::new()
                    [void]$AllModIds.Add($PrimaryModId)

                    if ($Fabric.provides) {
                        foreach ($ProvidedId in @($Fabric.provides)) {
                            $ProvidedId = [string]$ProvidedId

                            if ($ProvidedId -and $ProvidedId -notin $AllModIds) {
                                [void]$AllModIds.Add($ProvidedId)
                            }
                        }
                    }

                    return [PSCustomObject]@{
                        ModId          = $PrimaryModId
                        Name           = $DisplayName
                        Version        = $Version
                        Jar            = $File.Name
                        AllModIds      = ($AllModIds -join ';')
                        SHA256         = $Hash
                        MetadataPath   = $FabricEntry.Path
                        MetadataSource = 'Fabric JSON'
                        Confidence     = 'HIGH'
                        Namespaces     = ($Namespaces -join ';')
                    }
                }
            }
            catch {
                # Invalid or nonstandard fabric.mod.json.
                # Continue through the generic fallback chain.
            }
        }

        # --------------------------------------------------------
        # 3. Pack-style JAR
        # --------------------------------------------------------

        if ($PackMetadata) {
            $PrimaryModId = $FilenameIdentity.Id

            # For pack-style JARs, keep the human-readable Name tied to the
            # actual filename. Do NOT use pack.mcmeta description text here.
            # This preserves searchable naming such as v1, v2, etc.
            $DisplayName = $FilenameIdentity.Name
            $Version = $ManifestVersion
            $PackSource = 'Pack Metadata + Filename'

            if ([string]::IsNullOrWhiteSpace($DisplayName)) {
                $DisplayName = $PrimaryModId
            }

            if ([string]::IsNullOrWhiteSpace($Version)) {
                $Version = $FilenameIdentity.Version
            }
            else {
                $PackSource = 'Pack Metadata + JAR Manifest + Filename'
            }

            if ([string]::IsNullOrWhiteSpace($Version)) {
                $Version = 'UNKNOWN'
            }

            return [PSCustomObject]@{
                ModId          = $PrimaryModId
                Name           = $DisplayName
                Version        = $Version
                Jar            = $File.Name
                AllModIds      = $PrimaryModId
                SHA256         = $Hash
                MetadataPath   = $PackMetadata.Path
                MetadataSource = $PackSource
                Confidence     = 'MEDIUM'
                Namespaces     = ($Namespaces -join ';')
            }
        }

        # --------------------------------------------------------
        # 4. Generic JAR manifest
        # --------------------------------------------------------

        if (
            $ManifestEntry -and
            (
                $AutomaticModuleName -or
                $ManifestTitle -or
                $ManifestVersion
            )
        ) {
            $PrimaryModId = $null

            if ($AutomaticModuleName) {
                $PrimaryModId = ConvertTo-StableId $AutomaticModuleName
            }

            if ([string]::IsNullOrWhiteSpace($PrimaryModId)) {
                $PrimaryModId = $FilenameIdentity.Id
            }

            $DisplayName = $ManifestTitle

            if ([string]::IsNullOrWhiteSpace($DisplayName)) {
                $DisplayName = $FilenameIdentity.Name
            }

            $Version = $ManifestVersion

            if ([string]::IsNullOrWhiteSpace($Version)) {
                $Version = $FilenameIdentity.Version
            }

            if ([string]::IsNullOrWhiteSpace($Version)) {
                $Version = 'UNKNOWN'
            }

            return [PSCustomObject]@{
                ModId          = $PrimaryModId
                Name           = $DisplayName
                Version        = $Version
                Jar            = $File.Name
                AllModIds      = $PrimaryModId
                SHA256         = $Hash
                MetadataPath   = $ManifestEntry.Path
                MetadataSource = 'JAR Manifest + Filename'
                Confidence     = 'MEDIUM'
                Namespaces     = ($Namespaces -join ';')
            }
        }

        # --------------------------------------------------------
        # 5. Final generic filename fallback
        # --------------------------------------------------------

        $PrimaryModId = $FilenameIdentity.Id
        $DisplayName = $FilenameIdentity.Name
        $Version = $FilenameIdentity.Version

        if ([string]::IsNullOrWhiteSpace($PrimaryModId)) {
            $PrimaryModId = ConvertTo-StableId (
                [System.IO.Path]::GetFileNameWithoutExtension($File.Name)
            )
        }

        if ([string]::IsNullOrWhiteSpace($DisplayName)) {
            $DisplayName = $PrimaryModId
        }

        if ([string]::IsNullOrWhiteSpace($Version)) {
            $Version = 'UNKNOWN'
        }

        return [PSCustomObject]@{
            ModId          = $PrimaryModId
            Name           = $DisplayName
            Version        = $Version
            Jar            = $File.Name
            AllModIds      = $PrimaryModId
            SHA256         = $Hash
            MetadataPath   = ''
            MetadataSource = 'Filename Fallback'
            Confidence     = 'LOW'
            Namespaces     = ($Namespaces -join ';')
        }
    }
    catch {
        Write-Warning "Could not fully inspect $($File.Name): $($_.Exception.Message)"

        $Fallback = Get-FilenameIdentity $File.Name
        $Hash = (Get-FileHash -LiteralPath $File.FullName -Algorithm SHA256).Hash

        return [PSCustomObject]@{
            ModId          = $Fallback.Id
            Name           = $Fallback.Name
            Version        = $(if ($Fallback.Version) { $Fallback.Version } else { 'UNKNOWN' })
            Jar            = $File.Name
            AllModIds      = $Fallback.Id
            SHA256         = $Hash
            MetadataPath   = ''
            MetadataSource = 'Filename Fallback After Error'
            Confidence     = 'LOW'
            Namespaces     = ''
        }
    }
    finally {
        if ($Zip) {
            $Zip.Dispose()
        }
    }
}

# ============================================================
# GIT HELPERS
# ============================================================

function Test-GitAvailable {
    $SavedErrorActionPreference = $ErrorActionPreference

    try {
        $ErrorActionPreference = 'Continue'
        & git rev-parse --is-inside-work-tree 2>$null | Out-Null
        return ($LASTEXITCODE -eq 0)
    }
    catch {
        return $false
    }
    finally {
        $ErrorActionPreference = $SavedErrorActionPreference
    }
}

function Get-CommittedManifest {
    param([string]$Path)

    if (-not (Test-GitAvailable)) {
        return @()
    }

    $GitPath = $Path -replace '^[.][\\/]', ''
    $GitPath = $GitPath -replace '\\', '/'
    $GitSpec = "HEAD:$GitPath"

    $StartInfo = [System.Diagnostics.ProcessStartInfo]::new()
    $StartInfo.FileName = 'git'
    $StartInfo.UseShellExecute = $false
    $StartInfo.CreateNoWindow = $true
    $StartInfo.RedirectStandardOutput = $true
    $StartInfo.RedirectStandardError = $true

    [void]$StartInfo.ArgumentList.Add('cat-file')
    [void]$StartInfo.ArgumentList.Add('blob')
    [void]$StartInfo.ArgumentList.Add($GitSpec)

    $Process = $null
    $OutputStream = $null

    try {
        $Process = [System.Diagnostics.Process]::Start($StartInfo)

        if (-not $Process) {
            return @()
        }

        $OutputStream = [System.IO.MemoryStream]::new()

        $Process.StandardOutput.BaseStream.CopyTo(
            $OutputStream
        )

        [void]$Process.StandardError.ReadToEnd()

        $Process.WaitForExit()

        if ($Process.ExitCode -ne 0) {
            return @()
        }

        $BlobBytes = $OutputStream.ToArray()

        if ($BlobBytes.Length -eq 0) {
            return @()
        }

        $Offset = 0

        if (
            $BlobBytes.Length -ge 3 -and
            $BlobBytes[0] -eq 0xEF -and
            $BlobBytes[1] -eq 0xBB -and
            $BlobBytes[2] -eq 0xBF
        ) {
            $Offset = 3
        }

        $Utf8 = [System.Text.UTF8Encoding]::new(
            $false,
            $true
        )

        $CsvText = $Utf8.GetString(
            $BlobBytes,
            $Offset,
            $BlobBytes.Length - $Offset
        )

        if ([string]::IsNullOrWhiteSpace($CsvText)) {
            return @()
        }

        return @(
            $CsvText |
                ConvertFrom-Csv
        )
    }
    catch {
        return @()
    }
    finally {
        if ($OutputStream) {
            $OutputStream.Dispose()
        }

        if ($Process) {
            $Process.Dispose()
        }
    }
}

function Get-ExistingManifest {
    param([string]$Path)

    if (-not (Test-Path -LiteralPath $Path)) {
        return @()
    }

    try {
        return @(Import-Csv -LiteralPath $Path)
    }
    catch {
        return @()
    }
}

# ============================================================
# BUILD CURRENT MANIFEST
# ============================================================

if (-not (Test-Path -LiteralPath $ModsPath)) {
    throw "Mods directory not found: $ModsPath"
}

Write-Host "`n=== BUILDING CURRENT MOD MANIFEST ===" -ForegroundColor Cyan

$Current = @(
    Get-ChildItem -LiteralPath $ModsPath -File -Filter '*.jar' |
        Sort-Object Name |
        ForEach-Object {
            $Info = Get-ModInfo $_
            $FileVersion = Get-FileVersionToken `
                -FileName $Info.Jar `
                -MinecraftVersion $MinecraftVersion `
                -MetadataVersion $Info.Version

            $Info | Add-Member `
                -NotePropertyName FileVersion `
                -NotePropertyValue $FileVersion `
                -Force

            $Info
        } |
        Sort-Object ModId, Name
)

Write-Host "Active mod JARs found: $($Current.Count)"

# Read the already-generated local manifest before overwriting it.
# This is used only to suppress unchanged low-confidence notices.
$ExistingManifest = @(Get-ExistingManifest $ManifestPath)

# ============================================================
# IDENTITY VALIDATION
# ============================================================

$DuplicateIds = @(
    $Current |
        Group-Object ModId |
        Where-Object Count -gt 1
)

if ($DuplicateIds.Count -gt 0) {
    Write-Host "`n=== DUPLICATE PRIMARY MOD IDS ===" -ForegroundColor Red

    foreach ($Group in $DuplicateIds) {
        Write-Host "`n$($Group.Name)" -ForegroundColor Red

        $Group.Group |
            Select-Object ModId, Name, Version, Jar, MetadataSource |
            Format-Table -AutoSize |
            Out-Host
    }

    throw 'Duplicate primary ModIds detected. Manifest was not written.'
}

$UnknownVersions = @(
    $Current |
        Where-Object { $_.Version -eq 'UNKNOWN' }
)

# Low-confidence identities are only surfaced when they are new
# or the physical JAR changed since the last locally generated manifest.
$ExistingLowByHash = @{}
$ExistingLowByKey = @{}

foreach ($Mod in $ExistingManifest) {
    if ($Mod.Confidence -ne 'LOW') {
        continue
    }

    if (-not [string]::IsNullOrWhiteSpace($Mod.SHA256)) {
        $ExistingLowByHash[$Mod.SHA256] = $true
    }

    $Key = "$($Mod.ModId)|$($Mod.Jar)|$($Mod.Version)"
    $ExistingLowByKey[$Key] = $true
}

$LowConfidenceNeedsAttention = @(
    foreach ($Mod in ($Current | Where-Object { $_.Confidence -eq 'LOW' })) {
        $KnownUnchanged = $false

        if (
            -not [string]::IsNullOrWhiteSpace($Mod.SHA256) -and
            $ExistingLowByHash.ContainsKey($Mod.SHA256)
        ) {
            $KnownUnchanged = $true
        }
        else {
            $Key = "$($Mod.ModId)|$($Mod.Jar)|$($Mod.Version)"

            if ($ExistingLowByKey.ContainsKey($Key)) {
                $KnownUnchanged = $true
            }
        }

        if (-not $KnownUnchanged) {
            $Mod
        }
    }
)

# Do not print an audit section when there is nothing new to investigate.
# UNKNOWN versions always require attention. LOW-confidence entries only
# require attention when they are new or changed.
if (
    $UnknownVersions.Count -gt 0 -or
    $LowConfidenceNeedsAttention.Count -gt 0
) {
    Write-Host "`n=== IDENTIFICATION ATTENTION ===" -ForegroundColor Cyan

    if ($UnknownVersions.Count -gt 0) {
        Write-Host "`nUnknown versions:" -ForegroundColor Yellow

        $UnknownVersions |
            Select-Object ModId, Name, Version, Jar, MetadataSource, Confidence |
            Format-Table -AutoSize |
            Out-Host
    }

    if ($LowConfidenceNeedsAttention.Count -gt 0) {
        Write-Host "`nNew or changed low-confidence identities:" -ForegroundColor Yellow

        $LowConfidenceNeedsAttention |
            Select-Object ModId, Name, Version, Jar, MetadataSource |
            Format-Table -AutoSize |
            Out-Host
    }
}

# ============================================================
# LOAD LAST COMMITTED MANIFEST
# ============================================================

$Previous = @(Get-CommittedManifest $ManifestPath)
$FirstRun = ($Previous.Count -eq 0)

# ============================================================
# COMPARE
# ============================================================

$Added = @()
$Removed = @()
$Updated = @()

if (-not $FirstRun) {
    $PreviousById = @{}
    $PreviousByHash = @{}
    $PreviousByJar = @{}

    $MatchedPrevious = [System.Collections.Generic.HashSet[string]]::new(
        [System.StringComparer]::OrdinalIgnoreCase
    )

    foreach ($Mod in $Previous) {
        if ($Mod.ModId) {
            $PreviousById[$Mod.ModId] = $Mod
        }

        if ($Mod.SHA256) {
            if (-not $PreviousByHash.ContainsKey($Mod.SHA256)) {
                $PreviousByHash[$Mod.SHA256] = @()
            }

            $PreviousByHash[$Mod.SHA256] += $Mod
        }

        if ($Mod.Jar) {
            $PreviousByJar[$Mod.Jar] = $Mod
        }
    }

    foreach ($New in $Current) {
        $Old = $null

        # Match priority:
        # 1. Stable ModId
        # 2. Exact SHA256
        # 3. Exact JAR filename
        #
        # The SHA/JAR fallbacks prevent parser improvements from
        # reporting the same physical JAR as Removed + Added.
        if (
            $New.ModId -and
            $PreviousById.ContainsKey($New.ModId)
        ) {
            $Old = $PreviousById[$New.ModId]
        }
        elseif (
            $New.SHA256 -and
            $PreviousByHash.ContainsKey($New.SHA256) -and
            $PreviousByHash[$New.SHA256].Count -eq 1
        ) {
            $Old = $PreviousByHash[$New.SHA256][0]
        }
        elseif (
            $New.Jar -and
            $PreviousByJar.ContainsKey($New.Jar)
        ) {
            $Old = $PreviousByJar[$New.Jar]
        }

        if (-not $Old) {
            $Added += $New
            continue
        }

        [void]$MatchedPrevious.Add($Old.ModId)

        $MetadataVersionChanged = ($Old.Version -ne $New.Version)
        $JarChanged = ($Old.Jar -ne $New.Jar)
        $HashChanged = ($Old.SHA256 -ne $New.SHA256)

        if ($MetadataVersionChanged -or $JarChanged -or $HashChanged) {
            $OldReportVersion = Get-ReportVersion `
                -Mod $Old `
                -MinecraftVersion $MinecraftVersion

            $NewReportVersion = Get-ReportVersion `
                -Mod $New `
                -MinecraftVersion $MinecraftVersion

            $ReportVersionChanged = ($OldReportVersion -ne $NewReportVersion)

            # If filename versions cannot distinguish the update but the
            # embedded metadata can, use the embedded metadata versions.
            if (-not $ReportVersionChanged -and $MetadataVersionChanged) {
                $OldReportVersion = $Old.Version
                $NewReportVersion = $New.Version
                $ReportVersionChanged = ($OldReportVersion -ne $NewReportVersion)
            }

            $Reason = if ($ReportVersionChanged) {
                'Version changed'
            }
            elseif ($JarChanged) {
                'JAR changed at same version'
            }
            else {
                'File contents changed at same version'
            }

            $Updated += [PSCustomObject]@{
                ModId           = $New.ModId
                Name            = $New.Name
                OldVersion      = $Old.Version
                NewVersion      = $New.Version
                OldFileVersion  = Get-FileVersionToken -FileName $Old.Jar -MinecraftVersion $MinecraftVersion -MetadataVersion $Old.Version
                NewFileVersion  = $New.FileVersion
                OldReportVersion = $OldReportVersion
                NewReportVersion = $NewReportVersion
                OldJar          = $Old.Jar
                NewJar          = $New.Jar
                Reason          = $Reason
            }
        }
    }

    foreach ($Old in $Previous) {
        if (-not $MatchedPrevious.Contains($Old.ModId)) {
            $Removed += $Old
        }
    }
}

# ============================================================
# WRITE MANIFEST
# ============================================================

$Current |
    Select-Object `
        ModId,
        Name,
        Version,
        FileVersion,
        Jar,
        AllModIds,
        SHA256,
        MetadataPath,
        MetadataSource,
        Confidence,
        Namespaces |
    Export-Csv `
        -LiteralPath $ManifestPath `
        -NoTypeInformation `
        -Encoding UTF8

# ============================================================
# WRITE MARKDOWN CHANGE REPORT
# ============================================================

$Lines = [System.Collections.Generic.List[string]]::new()

[void]$Lines.Add('# Mod Changes')
[void]$Lines.Add('')
[void]$Lines.Add("Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')")
[void]$Lines.Add('')
[void]$Lines.Add("Active mod JARs: $($Current.Count)")
[void]$Lines.Add('')

if ($FirstRun) {
    [void]$Lines.Add('This is the initial mod manifest baseline.')
}
else {
    [void]$Lines.Add('## Added')
    [void]$Lines.Add('')

    if ($Added.Count -eq 0) {
        [void]$Lines.Add('- None')
    }
    else {
        foreach ($Mod in ($Added | Sort-Object Jar)) {
            [void]$Lines.Add(
                "- ``$($Mod.Jar)`` | Version: $(Get-ReportVersion -Mod $Mod -MinecraftVersion $MinecraftVersion) [$($Mod.ModId)]"
            )
        }
    }

    [void]$Lines.Add('')
    [void]$Lines.Add('## Removed')
    [void]$Lines.Add('')

    if ($Removed.Count -eq 0) {
        [void]$Lines.Add('- None')
    }
    else {
        foreach ($Mod in ($Removed | Sort-Object Jar)) {
            [void]$Lines.Add(
                "- ``$($Mod.Jar)`` | Version: $(Get-ReportVersion -Mod $Mod -MinecraftVersion $MinecraftVersion) [$($Mod.ModId)]"
            )
        }
    }

    [void]$Lines.Add('')
    [void]$Lines.Add('## Updated')
    [void]$Lines.Add('')

    if ($Updated.Count -eq 0) {
        [void]$Lines.Add('- None')
    }
    else {
        # For updated mods, show only the CURRENT JAR filename.
        # Added and Removed already identify exact old/new files, and repeating
        # two long filenames here makes the report unnecessarily noisy.
        #
        # This is generic for every mod, not a special case.
        foreach ($Mod in ($Updated | Sort-Object NewJar)) {
            if ($Mod.OldReportVersion -ne $Mod.NewReportVersion) {
                [void]$Lines.Add(
                    "- ``$($Mod.NewJar)`` | Version: $($Mod.OldReportVersion) -> $($Mod.NewReportVersion) [$($Mod.ModId)]"
                )
            }
            else {
                [void]$Lines.Add(
                    "- ``$($Mod.NewJar)`` | Version: $($Mod.NewReportVersion) ($($Mod.Reason)) [$($Mod.ModId)]"
                )
            }
        }
    }
}

$Lines | Set-Content -LiteralPath $ChangesPath -Encoding UTF8

# ============================================================
# CONSOLE REPORT
# ============================================================

Write-Host "`n=== MOD CHANGE REPORT ===" -ForegroundColor Cyan

if ($FirstRun) {
    Write-Host 'Initial baseline created.' -ForegroundColor Yellow
}
else {
    Write-Host "`nADDED: $($Added.Count)" -ForegroundColor Green

    foreach ($Mod in ($Added | Sort-Object Jar)) {
        Write-Host "  + $($Mod.Jar) | Version: $(Get-ReportVersion -Mod $Mod -MinecraftVersion $MinecraftVersion)"
    }

    Write-Host "`nREMOVED: $($Removed.Count)" -ForegroundColor Red

    foreach ($Mod in ($Removed | Sort-Object Jar)) {
        Write-Host "  - $($Mod.Jar) | Version: $(Get-ReportVersion -Mod $Mod -MinecraftVersion $MinecraftVersion)"
    }

    Write-Host "`nUPDATED: $($Updated.Count)" -ForegroundColor Yellow

    foreach ($Mod in ($Updated | Sort-Object NewJar)) {
        if ($Mod.OldReportVersion -ne $Mod.NewReportVersion) {
            Write-Host "  ~ $($Mod.NewJar) | Version: $($Mod.OldReportVersion) -> $($Mod.NewReportVersion)"
        }
        else {
            Write-Host "  ~ $($Mod.NewJar) | Version: $($Mod.NewReportVersion) ($($Mod.Reason))"
        }
    }
}

Write-Host "`nManifest: $ManifestPath" -ForegroundColor Cyan
Write-Host "Report:   $ChangesPath" -ForegroundColor Cyan
