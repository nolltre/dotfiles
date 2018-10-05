# dotfiles
Dotfiles for setting up the Linux environment *my way*


--------

Plus, you know, in order to use my Thinkpad USB keyboard with my KVM, as it lacks Scroll Lock, the following is necessary in `/usr/share/X11/xkb/symbols/pc` in order to replace the Insert key for Scroll Lock:

```bash
key <INS>  {        [ Scroll_Lock           ]       };
modifier_map Mod3   { Scroll_Lock, <INS> };
```

These dotfiles have been customized for my usage. The bits and pieces in them have been collected from all over the net/in forums etc. for many years so I don't know who originally wrote the stuff that I'm using.
