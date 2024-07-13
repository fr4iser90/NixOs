#/etc/nixos/modules/packages/developmentPackages.nix
{ pkgs, ... }:
with pkgs; [
  vscode             # Visual Studio Code, a code editor.
  kate               # Advanced text editor.
#  emacs              # Extensible, customizable text editor.
  vim                # Highly configurable text editor.
#  neovim             # Hyperextensible Vim-based text editor.
  sublime-text       # Sophisticated text editor for code, markup, and prose.
#  atom               # Hackable text editor for the 21st century.
#  intellij-idea-community # IntelliJ IDEA Community Edition, a powerful Java IDE.
#  pycharm-community  # PyCharm Community Edition, a Python IDE.
#  clion              # Cross-platform IDE for C and C++ by JetBrains.
#  qtcreator          # Cross-platform IDE tailored to the needs of Qt developers.
#  geany              # Lightweight IDE.
#  eclipse            # IDE for Java development.
#  monodevelop        # IDE for .NET and C# development.
#  android-studio     # Android development environment.
#  gitkraken          # Cross-platform Git GUI.
#  postman            # API development environment.
#  docker             # Platform for developing, shipping, and running applications.
#  kubectl            # Command-line tool for controlling Kubernetes clusters.
#  terraform          # Infrastructure as code software tool.
#  ansible            # Automation tool for IT tasks.
#  chefdk             # Development kit for Chef, a configuration management tool.
#  vagrant            # Tool for building and managing virtualized development environments.
#  heroku-cli         # Command-line interface for Heroku.
#  awscli             # Command-line interface for Amazon Web Services.
#  azure-cli          # Command-line interface for Microsoft Azure.
#  gdb                # GNU Debugger.
#  cmake              # Cross-platform build-system generator.
#  make               # Build automation tool.
#  bazel              # Build and test tool that scales to very large codebases.
#  maven              # Build automation tool used primarily for Java projects.
#  gradle             # Build automation tool for multi-language software development.
#  nodejs             # JavaScript runtime built on Chrome's V8 JavaScript engine.
#  npm                # Package manager for JavaScript.
#  yarn               # JavaScript package manager alternative to npm.
#  python3            # Python programming language, version 3.
#  ruby               # Ruby programming language.
#  go                 # Go programming language.
#  rustup             # Rust toolchain installer.
#  php                # PHP programming language.
#  perl               # Perl programming language.
#  elixir             # Elixir programming language.
#  haskell.compiler.ghc8104 # Glasgow Haskell Compiler.
#  racket             # General-purpose programming language in the Lisp-Scheme family.
#  julia              # High-performance programming language for technical computing.
#  sbcl               # Steel Bank Common Lisp, a Common Lisp implementation.
#  lua                # Lightweight scripting language.
]


