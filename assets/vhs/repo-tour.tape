Output assets/demo/repo-tour.webm
Set Shell bash
Set FontSize 28
Set Width 1600
Set Height 900
Set Theme {"background":"#1a1110","foreground":"#f1dedc","cursor":"#ffb3ac","selection":"#73332f","black":"#1a1110","red":"#ff7472","green":"#9aff7f","yellow":"#ffe472","blue":"#f29b93","magenta":"#76352f","cyan":"#ffb3ac","white":"#fff0ef","brightBlack":"#a59a99","brightRed":"#ffa09f","brightGreen":"#b8ffa5","brightYellow":"#ffeea5","brightBlue":"#ffbeb8","brightMagenta":"#ffc9c4","brightCyan":"#ffdcd9","brightWhite":"#fff9f8"}
Set Padding 28
Set Margin 24
Set MarginFill "#140d0c"
Set BorderRadius 14
Set WindowBar Colorful
Set TypingSpeed 45ms
Set CursorBlink false
Set Framerate 30
Env HOME "/tmp/showcase-home"
Env TERM "xterm-256color"
Env COLORTERM "truecolor"
Env LANG "C.UTF-8"
Env BAT_THEME "ansi"
Env GIT_PAGER "cat"
Env EDITOR "nvim"

Hide
Type "mkdir -p /tmp/showcase-home && export PS1=showcase@dotfiles:\\w\\$ && cd /home/nijigahara/.local/share/chezmoi && clear"
Enter
Sleep 200ms
Show

Type "ls"
Enter
Sleep 1100ms
Screenshot assets/demo/repo-tour.png

Type "bat --style=plain --color=always README.md | sed -n '1,38p'"
Enter
Sleep 1400ms

Type "clear"
Enter
Sleep 200ms
Type "ls dot_config"
Enter
Sleep 1000ms

Type "ls dot_config/ghostty/themes dot_config/matugen dot_config/zellij/themes"
Enter
Sleep 1000ms

Type "clear"
Enter
Sleep 200ms
Type "ls dot_config/gh dot_config/DankMaterialShell dot_config/obs-studio/basic/profiles/Untitled"
Enter
Sleep 1200ms

Type "clear"
Enter
Sleep 200ms
Type "bat --style=plain --color=always dot_config/systemd/user/chezmoi-auto-sync.timer"
Enter
Sleep 1000ms

Type "clear"
Enter
Sleep 200ms
Type "nvim dot_config/nvim/init.lua +29"
Enter
Sleep 1200ms
Type ":e lua/themes/dankcolors.lua"
Enter
Sleep 1400ms
Type ":qall!"
Enter
Sleep 300ms

Type "git status --short"
Enter
Sleep 1500ms
