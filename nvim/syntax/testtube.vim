" Vim syntax file
" Language: TestTube Manual Test Case Format
" Maintainer: Logan Frederick
" Latest Revision: 17 Feb 2026

if exists("b:current_syntax")
  finish
endif

syntax clear
syntax case ignore

syntax match TestTubeVerifyStatement /^Verify/
syntax match TestTubeNoteStatement /^Note:/
syntax match TestTubeNAStatement /\t*N\/A/
syntax match TestTubeTODOStatement /\t\+TODO/

syntax match TestTubeAction /^[^\t].*$/
syntax match TestTubeExpectedResult /^\t[^\t].*$/
syntax match TestTubeNotes /^\t\t.*$/
