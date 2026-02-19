function prompt
{
    <#
        Prompt Goals:
        - add sioyek to PATH
        - add nonproduct (scripts) folder to PATH
        - show PS version, since that bites me all the time
        - since I hate long windows paths, shorten them
        Eventually it would be nice to have colored output, but handling differs between PS versions
        #>

    # guard against repeat inclusion for subprocesses
    if ($env:PATH -notmatch 'Sioyek')
    { $env:Path += ';C:\Program Files\Sioyek' 
    }
    if ($env:PATH -notmatch 'professional\nonproduct\\scripts')
    {$env:Path += ';C:\Users\logan.frederick\Source\professional\nonproduct\scripts'
    }
    if ($env:PATH -notmatch 'personal\nonproduct\\scripts')
    {$env:Path += ';C:\Users\logan.frederick\Source\personal\nonproduct\scripts'
    }
    if ($env:PATH -notmatch 'qutebrowser')
    {$env:Path += ';C:\Users\logan.frederick\AppData\Local\Programs\qutebrowser\'
    }
    if ($env:PATH -notmatch 'MikeFarah.yq')
    {$env:Path += ';C:\Users\logan.frederick\AppData\Local\Microsoft\WinGet\Packages\MikeFarah.yq_Microsoft.Winget.Source_8wekyb3d8bbwe'
    }

    $major = $PSVersionTable.PSVersion.Major
    $minor = $PSVersionTable.PSVersion.Minor
    $version = "$major.$minor"

    $path = (Get-Location).Path

    $vhome = Join-Path $HOME 'OneDrive - Veranex'

    if ($path.StartsWith($vhome))
    {
        $formatted = '$VHOME' + $path.Substring($vhome.Length)
    } elseif ($path.StartsWith($HOME))
    {
        $formatted = '$HOME' + $path.Substring($HOME.Length)
    } else
    {
        $formatted = $path
    }

    return "$formatted PS $version> "
}

$env:EDITOR = 'nvim'
Set-PSReadlineoption -EditMode Vi

# Functions are kept here, in `nonproduct` for consistency

. "$($env:USERPROFILE)\Source\personal\nonproduct\scripts\personal_powershell_functions.ps1"
. "$($env:USERPROFILE)\Source\professional\nonproduct\scripts\professional_powershell_functions.ps1"

# Note: also this to system env vars for command palette use
$env:GLAZEWM_CONFIG_PATH = "C:\Users\logan.frederick\Source\personal\gh_dotfiles\glazeWM\config.yaml"

# This clever command from SO echoes "CMD" or the PS Version
function which_shell_am_i_trick
{
    (dir 2>&1 *`|echo CMD);&<# rem #>echo ($PSVersionTable).PSEdition
}

<#
Set the `FZF_DEFAULT_COMMAND` and `FZF_DEFAULT_OPTS` env vars so that 
`fzf` fuzzy finds on all the paths from the `fzf_default()` powershell
function and selection with `enter` will spawn a subprocess with that
path and open nvim if it is a file.
#>
function fzf_default
{
    $ErrorActionPreference = "Stop"
    gci -Recurse C:\Users\logan.frederick\Source | ? { $_.FullName -notmatch '\.venv|dependency_track|CMakeFiles|\.git|\.idea|docs' } | `
            Sort-Object -Property LastWriteTime -Descending | `
            % { "$($_.LastWriteTime)`t$(if (Test-Path -Path $_.FullName -PathType Container) {'D'} else {'F'})`t$($_.FullName)" }
}

function fzfind
{
    powershell.exe -command "fzf_default | fzf.exe -d \t -n 3 --bind 'enter:become(powershell.exe -NoExit -Command change_directory {3})'"
}

function change_directory
{
    Param([String]$s)

    $s = $s -replace '^',''

    if (Test-Path -Path $s -PathType Container)
    {
        Set-Location $s
    } elseif (Test-Path -Path $s -PathType Leaf)
    {
        Set-Location $(Split-Path -Path $s -Parent)
        $ext = (Get-Item $s).Extension

        if ($ext -eq '.pdf')
        {
            sioyek.exe $s
        } elseif ($ext -in @('.docx', '.doc', '.csv', '.xls', '.xlsx', '.ppt', '.pptx'))
        {
            Invoke-Item $s
        } else
        {
            nvim $s
        }
    } else
    {
        $s
    }
}

$env:FZF_DEFAULT_COMMAND = "powershell.exe -command fzf_default"
$env:FZF_DEFAULT_OPTS = ""
