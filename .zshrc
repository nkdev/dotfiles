#GGG =====================================================================
# 🌟 Zsh 共通設定 (dotfiles管理)
# =====================================================================

# --- 📁 1. 履歴（History）の強化 ---
# コマンドの履歴を10万件まで記憶（標準だとすぐ消えてしまうのを防ぐ）
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# 別のターミナルタブやウィンドウで打ったコマンドも、リアルタイムで履歴を共有する
setopt share_history
# 履歴に連続して全く同じコマンドが残らないようにする（矢印キーの履歴検索が綺麗になります）
setopt hist_ignore_dups


# --- ⌨️ 2. 補完機能・移動の強化 ---
# タブキー（Tab）を押したときの補完候補メニューを、矢印キーで上下左右に選べるようにする
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select

# ディレクトリ名（フォルダ名）を入力して Enter を押すだけで、前に「cd 」を打たなくても移動できるようにする
setopt auto_cd


# --- 🚀 3. エイリアス（便利なショートカットコマンド） ---
# 毎回長いコマンドを打つ手間を省くための設定です
alias ll='ls -laG'          # 隠しファイルもサイズも色付きで一覧表示
alias g='git'               # git コマンドを「g」だけで打てるようにする
alias gs='git status'       # git status を「gs」で一発確認
alias dot='cd ~/dotfiles'   # いつでも「dot」と打てば dotfiles フォルダへ一瞬で移動

# 【最重要】「vim」と打ったときに、自動で裏で最新の Neovim が立ち上がるようにする
alias vim='nvim'

# --- 🎨 4. コマンド自動色付けプラグインの読み込み ---
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# --- 🚀 5. Yazi (超高速ファイルマネージャー) 設定 ---
# 「y」とだけ打てば、自動移動機能付きで Yazi が起動するショートカット
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(cat "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# =====================================================================
# 📊 6. Zsh バースタイル・プロンプト視覚化カスタム (番号を修正)
# =====================================================================

# Gitの情報（ブランチ名など）を自動で取得するための仕組みをオンにする
autoload -Uz vcs_info
setopt prompt_subst

# Git内とGit外で、表示する中身と矢印を完全にコントロールします
zstyle ':vcs_info:git:*' formats '%b'
zstyle ':vcs_info:git:*' actionformats '%b|%a'

# すべての情報が矢印（）で綺麗にバトンリレーされるように色の階層を調整
# コマンド実行前に、Gitの内外に応じて「中身」と「矢印の色」を完全に計算し分ける関数
precmd() {
    vcs_info
    if [ -n "$vcs_info_msg_0_" ]; then
        # 🟢 Gitフォルダ内にいる場合：
        # フォルダ（青）からGit（緑）への矢印を繋ぎ、最後は緑から通常背景への矢印（）で締める
        GIT_SEGMENT="%K{green}%F{blue}%f%F{black}  ${vcs_info_msg_0_} %k%F{green}%f"
    else
        # ⚪ Git外のフォルダにいる場合：
        # フォルダ（青）からGit外（グレー）への矢印を繋ぎ、最後はグレーから通常背景への矢印（）で締める
        GIT_SEGMENT="%K{242}%F{blue}%f%F{white} 🔒Git外 %k%F{242}%f"
    fi
}

# 1段目の共通パーツ（時間 ➔ フォルダ）と、上で計算した動的パーツ（Git内/外）を完全に融合
PROMPT='%K{238}%F{cyan} 🕒 %* %k%F{238}%K{blue}%f%F{black}  %~ ${GIT_SEGMENT}
%F{neon}%#%f '

# =====================================================================
# 🚀 7. 過去の履歴から先回りして予測表示するプラグイン (連番確定版)
# =====================================================================
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
