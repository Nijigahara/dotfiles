Output assets/demo/bootstrap.webm
Set Shell bash
Set FontSize 28
Set Width 1500
Set Height 860
Set Theme {"background":"#1a1110","foreground":"#f1dedc","cursor":"#ffb3ac","selection":"#73332f","black":"#1a1110","red":"#ff7472","green":"#9aff7f","yellow":"#ffe472","blue":"#f29b93","magenta":"#76352f","cyan":"#ffb3ac","white":"#fff0ef","brightBlack":"#a59a99","brightRed":"#ffa09f","brightGreen":"#b8ffa5","brightYellow":"#ffeea5","brightBlue":"#ffbeb8","brightMagenta":"#ffc9c4","brightCyan":"#ffdcd9","brightWhite":"#fff9f8"}
Set Padding 28
Set Margin 24
Set MarginFill "#140d0c"
Set BorderRadius 14
Set WindowBar Colorful
Set TypingSpeed 40ms
Set CursorBlink false
Set Framerate 30
Env HOME "/tmp/showcase-home"
Env TERM "xterm-256color"
Env COLORTERM "truecolor"
Env LANG "C.UTF-8"
Env GIT_PAGER "cat"

Hide
Type "mkdir -p /tmp/showcase-home && export PS1=showcase@dotfiles:\\w\\$ && cd /home/nijigahara/.local/share/chezmoi && clear"
Enter
Sleep 200ms
Show

Type "printf 'gpg --import ~/.local/share/demo-keys/public.asc\\ngpg --import ~/.local/share/demo-keys/secret.asc\\nchezmoi init https://github.com/Nijigahara/dotfiles.git\\nchezmoi apply\\nchezmoi status\\n'"
Enter
Sleep 1500ms
