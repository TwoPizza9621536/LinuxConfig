try { $null = Get-Command concfg -ea stop; concfg tokencolor -n enable } catch { }
Import-Module oh-my-posh
Import-Module posh-git
Set-PoshPrompt -Theme agnoster
