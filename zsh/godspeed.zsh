# Source after zsh-syntax-highlighting to set its styles. No prompt is replaced.
# GODSPEED_VARIANT=whirlwind source /path/to/godspeed/zsh/godspeed.zsh
_godspeed_dir=${0:A:h}
case ${GODSPEED_VARIANT:-thunderbolt} in
  thunderbolt|whirlwind) source "${_godspeed_dir}/${GODSPEED_VARIANT:-thunderbolt}.zsh" ;;
  *) print -u2 'godspeed: GODSPEED_VARIANT must be thunderbolt or whirlwind'; return 1 ;;
esac
unset _godspeed_dir

# Named colours can also be used in prompts, e.g. %F{$GODSPEED_CYAN}❯%f.
if (( ${+ZSH_HIGHLIGHT_STYLES} )); then
  ZSH_HIGHLIGHT_STYLES[command]="fg=$GODSPEED_CYAN"
  ZSH_HIGHLIGHT_STYLES[builtin]="fg=$GODSPEED_VIOLET"
  ZSH_HIGHLIGHT_STYLES[alias]="fg=$GODSPEED_VIOLET"
  ZSH_HIGHLIGHT_STYLES[single-quoted-argument]="fg=$GODSPEED_GREEN"
  ZSH_HIGHLIGHT_STYLES[double-quoted-argument]="fg=$GODSPEED_GREEN"
  ZSH_HIGHLIGHT_STYLES[unknown-token]="fg=$GODSPEED_RED,underline"
fi
