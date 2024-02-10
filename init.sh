#!/bin/bash

command_exists () {
    type "\$1" &> /dev/null ;
}

install_formula () {
    if brew list $1 &> /dev/null; then
        echo $1 is already installed
    else
        echo Installing $1...
        brew install $1
    fi
}

echo system setup started......

if command_exists brew ; then
    echo "Homebrew is already installed"
else
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

formulas=(
    "fish"
    "rustup-init"
    "zoxide"
    "atuin"
    "starship"
    "fzf"
    "ripgrep"
)

for formula in "${formulas[@]}"; do
    install_formula $formula
done

# Run starship preset
starship preset plain-text-symbols -o ~/.config/starship.toml

# Replace fishshell config
cat > ~/.config/fish/config.fish << EOF
set fish_greeting

if status is-interactive
    # https://github.com/atuinsh/atuin
    atuin init fish --disable-up-arrow | source
    # https://github.com/ajeetdsouza/zoxide
    zoxide init --cmd j fish | source
    # https://starship.rs
    starship init fish | source
end

abbr --add rl exec fish

abbr --add l ls -lAhF

abbr --add c code

abbr --add c. code .
EOF
