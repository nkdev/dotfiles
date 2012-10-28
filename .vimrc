"####################
" システム
"####################
set nocompatible "vi非互換モード
"### vundle setting
filetype off

set rtp+=~/.vim/vundle.git/
call vundle#rc()

"## original repos on github

"## vim-scripts repos

"## non github repos

filetype plugin indent on

set helplang=ja "Helpを日本語優先

"####################
" 分割ファイル読み込み
"####################
runtime! usrautoload/charcode.vim "文字コード関連

"####################
" キーバインド
"
" map:再帰的マッピング, unmap:マップ解除, noremap:マッピング
" map :ノーマルモード、ビジュアルモード、オペレータ待機モード
" vmap:ビジュアルモード
" nmap:ノーマルモード
" omap:オペレータ待機モード
" map!:インサートモード、コマンドライン
" imap:インサートモード
" cmap:コマンドライン
"####################
"### 括弧保管
imap { {}<LEFT>
imap [ []<LEFT>
imap ( ()<LEFT>
"### 物理行移動
nnoremap j gj
nnoremap k gk
nnoremap <Down> gj
nnoremap <Up> gk
"### <BS>削除
noremap  
noremap!  
noremap <BS> 
noremap! <BS> 
"### insert modeでのemacs移動
inoremap <C-e> <END>
inoremap <C-a> <HOME>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>

"####################
" 表示系
"####################
syntax on "カラー表示
set laststatus=2 "ステータスラインを常に表示
set statusline=%F%m%r%h%w\ [%{&fenc}/%{&ff}]\ [%Y]\ %=[%04v,%04l/%L][%p%%] "ステータス表示フォーマット
"set number "行番号表示
set showmode "モード表示
set title "編集中のファイル名表示
set ruler "ルーラーの表示
set showcmd "入力中のコマンドをステータスに表示
set showmatch "括弧入力時の対応する括弧表示
set background=dark
"colorscheme molokai "カラー表示スキーマ
"set list "不過視文字の表示
"set listchars=tab:▸\ ,eol:¬ "不過視文字表示設定
"set listchars=tab:>-,trail:-,nbsp:%,extends:>,precedes:<
"### タブをハイライトさせる
function! TabHilight()
  syntax match Tab /\t/ display containedin=ALL
  highlight Tab
    \ term=underline ctermbg=Lightmagenta guibg=Lightmagenta
endf
"### 行末スペースをハイライトさせる(\sだとタブ＆スペースに反応)
function! EOLSpaceHilight()
  syntax match EOLSpace / \+$/ display containedin=ALL
  highlight EOLSpace
    \ term=underline ctermbg=Darkmagenta guibg=Darkmagenta
endf
"### 全角スペースをハイライトさせる
function! JISX0208SpaceHilight()
  syntax match JISX0208Space /　/ display containedin=ALL
  highlight JISX0208Space
    \ term=underline ctermbg=LightCyan guibg=LightCyan
endf
"### syntaxの有無をチェックし、新規バッファと新規読み込み時にハイライトさせる
if has("syntax")
  syntax on
    augroup invisible
    autocmd! invisible
    autocmd BufNew,BufRead * call EOLSpaceHilight()
    autocmd BufNew,BufRead * call JISX0208SpaceHilight()
    autocmd BufNew,BufRead * call TabHilight()
  augroup END
endif

"### カレントウインドウに罫線を引く
augroup cch
  autocmd! cch
  autocmd WinLeave * set nocursorline
  autocmd WinLeave * set nocursorcolumn
  autocmd WinEnter,BufRead * set cursorline
  autocmd WinEnter,BufRead * set cursorcolumn
augroup END

"####################
" プログラミングヘルプ系
"####################
set smartindent "オートインデント
"### タブ入力表示設定
set expandtab "タブの代わりに空白文字挿入
set tabstop=2 "<Tab>が対応する空白の数
set shiftwidth=2 "インデントの空白の数
set softtabstop=0 "<Tab>や<BS>での編集時の<Tab>が対応する空白の数
"### ファイルオープン時に前回終了行で起動
if has("autocmd")
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal! g'\"" |
    \ endif
endif
"### 複数行ペーストのインデント問題回避
if &term =~ "xterm"
  let &t_ti .= "\e[?2004h"
  let &t_te .= "\e[?2004l"
  let &pastetoggle = "\e[201~"
  function XTermPasteBegin(ret)
    set paste
    return a:ret
  endfunction
  noremap <special> <expr> <Esc>[200~ XTermPasteBegin("0i")
  inoremap <special> <expr> <Esc>[200~ XTermPasteBegin("")
  cnoremap <special> <Esc>[200~ <nop>
  cnoremap <special> <Esc>[201~ <nop>
endif

"### コメント行で改行したときにコメント行にしない
autocmd FileType * setlocal formatoptions-=r
autocmd FileType * setlocal formatoptions-=o

"####################
" 検索系
"####################
set ignorecase "検索時に大文字小文字の区別なく検索
set smartcase "検索文字列に大文字がある場合は大文字小文字を区別して検索
set wrapscan "検索時に最後まで言ったら最初に戻る
set noincsearch "検索文字列入力時にジュンジ対象文字列にヒットさせない
set hlsearch "検索結果文字列のハイライト表示
vnoremap z/ <ESC>/\%V
vnoremap z? <ESC>?\%V

"####################
" plugin系
"####################
"### netrw設定:ディレクトリツリー表示系
let g:netrw_liststyle = 3 "netrwは常にtree view
let g:netrw_list_hide = 'CVS,\(^\|\s\s\)\zs\.\S\+' "CVSは表示しない
let g:netrw_altv = 1 "'v'でファイルを開くときは右側に開く
let g:netrw_alto = 1 "'o'でファイルを開くときは下側に開く

"### matchit設定:
let b:match_words = 
    \"<if>:<endif>,,<if>:<fi>,<bigin>:<end>,(:),{:},[:]" "\%移動のマッチケース
let b:match_ignorecase = 1 "大文字小文字を無視

"### autocompletion設定:<Tab>キーで保管
function! InsertTabWrapper()
  let col = col('.')-1
  if !col || getline('.')[col-1] !~ '\k'
  return "\<TAB>"
  else
  if pumvisible()
    return "\<C-N>"
  else
    return "\<C-N>\<C-P>"
  end
  endif
endfunction
inoremap <Tab> <c-r>=InsertTabWrapper()<cr>
autocmd FileType javascript
    \ :set dictionary=/usr/share/vim/vim73/syntax/javascript.vim
autocmd FileType html
    \:set dictionary=~/.vim/syntax/html.vim
"highlight Pmenu ctermbg=7 ctermfg=7
"highlight PmenuSel ctermbg=2 ctermfg=7
"highlight PmenuSbar ctermbg=2

"####################
" TIPS
"####################
" Ctrl-a :インクリメント, Ctrl-x :デクリメント
" :e ++enc=*** :エンコード変更でファイル開き直し
" :e! :ファイル開き直し
" w :単語単位で進む, b :単語単位で戻る

