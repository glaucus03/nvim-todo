" nvim-todo.vim

" Luaモジュールの読み込みと初期化
lua << EOF
require('nvim-todo').setup()
EOF

" タスク検索コマンドの定義
command! TodoSearch lua require('nvim-todo.ui.telescope_integration').search_tasks()

" タスク追加コマンドのダミー実装（詳細な実装はLuaで行う）
command! -nargs=+ TodoAdd lua require('nvim-todo.core').add_task(<f-args>)

" タスク状態更新コマンドのダミー実装（詳細な実装はLuaで行う）
command! -nargs=+ TodoUpdateStatus lua require('nvim-todo.core').update_task_status(<f-args>)

