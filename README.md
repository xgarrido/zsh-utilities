# zsh-functions

How to install
--------------

### In your ~/.zshrc

* Download the script or clone this repository:

``` bash
$ git clone git://github.com/xgarrido/zsh-functions.git
```

* Source all the scripts **at the end** of `~/.zshrc`:

``` bash
$ for plugin in /path/to/zsh-snailware/*.plugin.zsh; do source $plugin; done
```

* Source `~/.zshrc`  to take changes into account:

``` bash
$ source ~/.zshrc
```

### With oh-my-zsh

* Download the script or clone this repository in [oh-my-zsh](http://github.com/robbyrussell/oh-my-zsh) plugins directory:

``` bash
$ cd ~/.oh-my-zsh/custom/plugins
$ git clone git://github.com/xgarrido/zsh-snailware.git
```

* Activate the plugin in `~/.zshrc` (in **last** position):

``` bash
plugins=( [plugins...] zsh-snailware)
```

* Source `~/.zshrc`  to take changes into account:

``` bash
$ source ~/.zshrc
```

### With [antigen](https://github.com/zsh-users/antigen)

* Add this line to your `~/.zshrc` file:

``` bash
antigen-bundle xgarrido/zsh-functions
```

* To use the `nemo` theme write:

``` bash
antigen-theme xgarrido/zsh-functions nemo
```

