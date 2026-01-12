# TeaShellF :tea:

my tea shelf where all important things are stored - dotfiles
This is my attempt to track and automate my configurations for Linux.

This is intended for my personal use and thus there is no versioning and no gurantee anything will work.
It is here for my personal use and also to share for anybody who is interested for informationl use.



## Installation

I would not recommend installing this! Why would you? You will get a system tailored for my needs without knowing how
to utilize it. If you knew it you would not copy it.

But for me there is the `tea` cli to bootstap and manage this, you could adapt it for you and copy it, if you think its nice.

I also created ansible roles for this in another repo, you can check out if you like.


## Organization

There is a `dotfiles` subfolder, here I organize my configs in a way I think its comfortable.
The `tea` subdir is to manage my cli for maintaining and managing my system configs.

`docs` may contain more detailed information about anything.
`dotfiles/.private` is a placeholder, where everything inside will be ignored by git. This folder will be used for templated that are rendered or any system specific configs, 
that I do not want to end up in my repo, but could 'source' from a known location.
`teagarden` is my manifest file of my repos and subfolders for how I want to organize my system setup.
`targets` is yaml files that describe what configs get symlinked where - this is consumed by `tea` or `ansible`.


## Credits & Resources

Here I want to mention and thank some people or projects.
I got inspired for this section by [NotAShelf](https://github.com/NotAShelf) as he used this in his [nyx](https://github.com/NotAShelf/nyx?tab=readme-ov-file#credits--special-thanks).
So I can start with it - this looks like a valuable place to learn about Nix. I did not dig into it yet, but the 'Readme' alone already gave me some inspirations. Also in his repo are resources about Nix
linked that look very useful and comprehensive.


Thanks also to [Anish Athalye](https://github.com/anishathalye) and [dotbot](https://github.com/anishathalye/dotbot) this (when I remember correct) started my dotfiles journey.

### zsh

For my zsh config I need to thank [The Valuable Dev](https://thevaluable.dev/) I learned a lot about zsh from his blog and got good inspiration from his [dotfiles](https://github.com/Phantas0s/.dotfiles).
His Blog was one of the first making me 'see' more of zsh than only [oh-my-zsh](https://ohmyz.sh/) (which in general is a nice framework, but I am only using some plugins of it anymore).

Also shoutout to [mattmc3](https://github.com/mattmc3) for his zsh projects, foremost [antidote](https://github.com/mattmc3/antidote) and [zdotdir](https://github.com/getantidote/zdotdir). These two helped me get my zsh settings way better and opened me to new resources digging deeper into zsh.

[zsh users](https://github.com/zsh-users) is an awesome project, and offers some great resources. 

[zdharma continuum](https://github.com/zdharma-continuum) also is a place with very useful resources (altough I used zinit a bit, I never really got 'warm' with it and changed for antidote).

[zsh lovers](https://grml.org/zsh/zsh-lovers.html) is great, and if you like zsh you will really appreciate this! See also the links at the end for awesome additional resources.



### (n)vim

My editor of choice is neovim and the surrounding ecosystem (and this includes vim, where my journey stated).

[tjdevries](https://github.com/tjdevries) for his work on nvim [his youtube](https://www.youtube.com/@teej_dv) and the [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim/) which is the base for my nvim lua setup.

[Folke Lemaitre](https://github.com/folke) for his countless contributions to the nevim ecosystem and of course I learned much from his code and copied some parts of his [LazyVim](https://github.com/LazyVim/LazyVim) to improve my setup.
Also his [plugin manager](https://github.com/folke/lazy.nvim) really made me have a cleaner and nicer setup.

[Tim Pope](https://github.com/tpope) for his contributions to the vim ecosystem and some really nice plugins I use or did use. A valuable resource to learn vimscript (which I gave up in favor of lua), but especially of how to utilize (n)vim nicely.

### other

For the Ansible part I got a lot inspiration by [Logan Marchione](https://github.com/loganmarchione) [here](https://github.com/loganmarchione/ansible-arch-linux).

There are countless 'dotfiles' and blogs that got me inspired, that I cannot name anymore. But in general thanks to all the people sharing this in the public and helping others achieve nice results! It is a valuable resource for everybody trying to improve their tool and workspace customization and share knowledge.

### More Resources

Here also some resources that helped me learn much, alongside the 'dotfile repos' and the source code of some of the tools I use.

- [the missing semester](https://missing.csail.mit.edu/) was a valuable resource for me, getting started with some of the command line stuff.
- [The Valuable Dev](https://thevaluable.dev/)  as a blog was a great resource, especially getting my 'zsh' config to the next level and getting rid of 'omz'(I dont think its a bad project, but I used  (and still use) a little subset of it, and it made my startup time slow).
- [Drew Neils Vimcasts](http://vimcasts.org/) Vimcasts as well as his books gave my (n)vim usage a bit boost, after getting started with 'vimtutor'.
- [from bash to zsh](https://www.bash2zsh.com/) This book was a valuable resource to better understand zsh.
=======
## Credits

Here I want to mention and thank some people or projects.
I got inspired for this section by [@NotAShelf](https://github.com/NotAShelf) as he used this in his [nyx](https://github.com/NotAShelf/nyx?tab=readme-ov-file#credits--special-thanks).
So I can start with it - this looks like a valuable place to learn about Nix. I did not dig into it yet, but the 'Readme' alone already gave me some inspirations.

For my zsh config I need to thank [The Valuable Dev](https://thevaluable.dev/) I learned a lot about zsh from his blog and got good inspiration from his [dotfiles](https://github.com/Phantas0s/.dotfiles).

For the Ansible part I got a lot inspiration by [Logan Marchione](https://github.com/loganmarchione) [here](https://github.com/loganmarchione/ansible-arch-linux).

[tjdevries](https://github.com/tjdevries) for his work on vim [his youtube](https://www.youtube.com/@teej_dv) and the [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim/) which is the base for my nvim lua setup.
[Folke Lemaitre](https://github.com/folke) for his countless contributions to the nevim ecosystem and of course I learned much from his code and copied some parts of his [LazyVim](https://github.com/LazyVim/LazyVim) to improve my setup.
[Tim Pope](https://github.com/tpope) for his contributions to the vim ecosystem and some really nice plugins I use or did use. A valuable resource to learn vimscript (which I gave up in favor of lua), but especially of how to utilize (n)vim nicely.

There are countless 'dotfiles' and blogs that got me inspired, that I cannot name anymore. But in general thanks to all the people sharing this in the public and helping others achieve nice results!

## Resources

Here also some resources that helped me learn much, alongside the 'dotfile repos' and the source code of some of the tools I use.

[the missing semester](https://missing.csail.mit.edu/) was a valuable resource for me, getting started with some of the command line stuff.
[The Valuable Dev](https://thevaluable.dev/)  as a blog was a great resource, especially getting my 'zsh' config to the next level and getting rid of 'omz'(I dont think its a bad project, but I used  (and still use) a little subset of it, and it made my startup time slow).
[Drew Neils Vimcasts](http://vimcasts.org/) Vimcasts as well as his books gave my (n)vim usage a bit boost, after getting started with 'vimtutor'.
[from bash to zsh](https://www.bash2zsh.com/) This book was a valuable resource to better understand zsh.
