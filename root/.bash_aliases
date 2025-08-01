alias ll="ls -lha"
alias ?="grep"

alias apt="sudo apt"
alias install="apt install"
alias i="apt install"
alias remove="apt remove"
alias purge="apt purge"
alias update="apt update"
alias search="apt-cache search"
alias serach="apt-cache search"
alias s="apt-cache search"

alias unstage="git restore --staged"
alias ci="git commit"
alias st="git status"
alias status="git status"
alias add="git add"
alias push="git push"
alias pull="git pull"
alias revert="git restore"
alias revert-all="git restore ."
alias restore="git restore"
alias restore-all="git restore ."

alias up="docker compose up -d"
alias down="docker compose down"
alias build="docker compose build --no-cache"
alias logs="docker compose logs"
alias dps="docker compose ps"

alias sync="git pull && git push"

alias commit="claude -p \"Commite o que está no estágio com mensagem apropriada e convenção da comunidade\" --allowedTools \"Bash(git:*)\""
#alias commit="gemini -y -p \"Commite o que está no estágio com mensagem apropriada e convenção da comunidade.\" "
B

