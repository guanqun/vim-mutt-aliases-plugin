muttaliases.vim
===============

Auto complete Mutt aliases according to the file `~/.mutt/aliases`.
This is especially useful for users who are editing Mutt mails via vim.

Installation
------------

Put file `mutt-aliases.vim` into some place you're most comfortable with.
Add the below line into your `~/.vimrc` file:

    source <the-path-to-your-stored-mutt-aliases-vim-file>

Usage
-----

If you're editting file in Mutt:

    From: Lu Guanqun <guanqun.lu@gmail.com>
    To: foo
    Cc: 
    Subject: about mutt aliases plugin
    Reply-To: 

And your cursor is just after `foo`, hit `Ctrl+X Ctrl+U` to get the full
name.

    From: Lu Guanqun <guanqun.lu@gmail.com>
    To: My Foo <foo@bar.com>
    Cc: 
    Subject: about mutt aliases plugin
    Reply-To: 

Of course, I assume you have a record in your `~/.mutt/aliases`

    alias foo My Foo <foo@bar.com>

License
-------

Distributable under the same terms as Vim itself.  See `:help license`.
