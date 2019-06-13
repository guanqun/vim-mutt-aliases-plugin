Complete `mutt` aliases (listed in `~/.mutt/aliases`) inside Vim;
useful when using `Vim` as editor for `mutt`.

# Usage

When you're editing a mail file in Vim that reads
```
    From: Lu Guanqun <guanqun.lu@gmail.com>
    To: foo
```
and in your alias file have a record
```
    alias foo My Foo <foo@bar.com>
```
and your cursor is right after `foo`, then hit `Ctrl+X Ctrl+U` to obtain:
```
    From: Lu Guanqun <guanqun.lu@gmail.com>
    To: My Foo <foo@bar.com>
```
# Commands

The command `:EditAliases` opens the mutt aliases file in `Vim`.
(For less typing, you can (command-line) alias it to `ea` by [vim-alias](https://github.com/Konfekt/vim-alias))

To complete e-mail addresses inside Vim press `CTRL-X CTRL-U` in insert
mode. See `:help i_CTRL-X_CTRL-U` and `:help compl-function`.

# Setup

The mutt aliases file is set by `$alias_file` in the file `~/.muttrc`. To
explicitly set the path to a mutt aliases file `$file`, add to your `.vimrc` the line

```vim
  let g:muttaliases_file = '$file'
```

For example, `$file` could be

```
  ~/.mutt/aliases
```

# Related Plug-in

The plugin https://github.com/Konfekt/vim-mailquery lets you complete e-mail
addresses in Vim by those in your Inbox (or any other mail folder).

# Credits

Forked from [Lu Guanqun](mailto:guanqun.lu@gmail.com)'s [vim-mutt-aliases-plugin](https://github.com/guanqun/vim-mutt-aliases-plugin/tree/063a7bdd0d852a118253278721f74a053776135d).

# License

Distributable under the same terms as Vim itself.  See `:help license`.

