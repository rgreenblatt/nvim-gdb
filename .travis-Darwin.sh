#!/bin/bash -x

mkdir -p $HOME/bin

curl -LO https://github.com/neovim/neovim/releases/download/v0.3.4/nvim-macos.tar.gz
tar -xf nvim-macos.tar.gz
cat >$HOME/bin/nvim <<EOF
#!/bin/bash
`pwd`/nvim-osx64/bin/nvim "\$@"
EOF
chmod +x $HOME/bin/nvim

cat >$HOME/bin/lldb <<'EOF'
#!/bin/bash
PATH=/usr/bin /usr/bin/lldb "$@"
EOF
chmod +x $HOME/bin/lldb

brew install lua@5.1
