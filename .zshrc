# ==========================================
# 1. ENVIRONMENT VARIABLES
# ==========================================
export EDITOR="nvim"
export VISUAL="nvim"
export TERMINAL="kitty"
export BROWSER="firefox"

# ==========================================
# 2. PNPM & NODE ECOSYSTEM
# ==========================================
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Add local bin to path for globally installed node tools
export PATH="$HOME/.local/bin:$PATH"

# ==========================================
# 3. HISTORY OPTIMIZATIONS
# ==========================================
HISTFILE=~/.zsh_history
HISTSIZE=50000
SAVEHIST=50000
setopt appendhistory
setopt sharehistory
setopt incappendhistory
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt hist_ignore_space

# ==========================================
# 4. CUSTOM "ASH & ORANGE" PROMPT
# ==========================================
# %F{8} = Ash / Dark Gray (from Kitty color8)
# %F{7} = Light Gray (from Kitty color7)
# %F{3} = Bright Orange/Amber (from Kitty color3)
autoload -Uz colors && colors
setopt prompt_subst

# The prompt: [user@matcha] ~/current/dir 
# ❯ 
PROMPT=$'\n%B%F{8}[%n@%m]%f %F{7}%~%f\n%F{3}❯%f%b '

# ==========================================
# 5. ALIASES & WORKFLOW
# ==========================================
# Eza (Modern LS)
alias ls="eza --icons=always --group-directories-first"
alias ll="eza -lh --icons=always --group-directories-first"
alias la="eza -lah --icons=always --group-directories-first"
alias tree="eza --tree --icons=always"

# Neovim Shortcut
alias v="nvim"
alias vi="nvim"
alias vim="nvim"

# Turborepo & Pnpm Shortcuts
alias p="pnpm"
alias px="pnpm dlx"
alias tu="pnpm turbo run"
alias dev="pnpm turbo run dev"

# System updates (Fedora specific)
alias update="sudo dnf upgrade --refresh"

# ==========================================
# 6. ZOXIDE INIT (Must be at the bottom)
# ==========================================
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
