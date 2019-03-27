# Common Commands

To Update submodules and download

```powershell
git submodule update --init --recursive
git submodule update --recursive
```

to publish dev changes with interesting name... that doesn't have much value but entertainment. Run `install-module Nameit -scope currentuser` first and then run the following:
```powershell
git add . ; git commit -m "commit-$(invoke-generate '[adjective]-[noun]')"; git push
```