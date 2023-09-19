# Somewhat easy ONB (Open Net Battle) server setup
*aka ezservers?* 😉

This guide will set you up with your own ONB server with:
- the ONB server
- ezlibs server scripts, which let you easily add NPCs, Shops, Items, and more.
- an update script for easy updating in future
- git version tracking, so you can track all your changes and collaborate with others

**If you dont care about any of that and just want a quick server, go to the #builds channel in the discord, download the latest zip and run the exe**
but if you have a big project in mind I encourage continuing 

first, you will need git in order to use this template, and if git does not work immediately after install, try restarting your pc.
#### Git Download links
[windows](https://git-scm.com/download/win)

## Standard Windows setup 
1. open a command prompt / PowerShell / terminal window in the folder you would like to start in.
`on windows you can hold SHIFT and Right Click in the folder`
1. paste and run `git clone --recurse-submodules --remote-submodules https://github.com/Keristero/onb-server-template.git`
1. open the newly created folder (onb-server-template)
1. run run.bat `run.bat`
1. If all goes well, you should now be able to visit your server in game at `127.0.0.1:8765`

## Docker Windows setup (cool kids alternative)
There is not much advantage to running the server in docker, but you can have it auto start and auto reboot when it crashes
1. Download and install [Docker Desktop](https://www.docker.com/products/docker-desktop/)
1. Restart PC, yes, you have to...
1. open a command prompt / PowerShell / terminal window in the folder you would like to start in.
`on windows you can hold SHIFT and Right Click in the folder`
1. paste and run `git clone --recurse-submodules --remote-submodules https://github.com/Keristero/onb-server-template.git`
1. run docker_run.bat `docker_run.bat`

## Docker Linux setup
Nicer than on windows.
1. I assume you already know how to do this, but after you install docker engine, its basically just...
2. sources/docker-compose up

- From memory docker engine will autorun on linux by default? pretty cool.

## A note of caution
- If you edit any of the files in `ezlibs-scripts` or `ezlibs-custom`, the update script wont work anymore, if you have any customizations to make to ezlibs, open a pull request to the repository on my github, or limit them to the `ezlibs-custom\custom.lua` file

## After setting up your server...
- Edit maps using the [Tiled Map editor](https://www.mapeditor.org/), you can find guides in #help and #area-creators on the discord
- Check out the server documentation [here](https://github.com/TheMaverickProgrammer/OpenNetBattle), and the ezlibs documentation [here](https://github.com/Keristero/ezlibs-scripts) to see all the cool things servers can do.
- Set up [Visual Studio Code](https://code.visualstudio.com/) with the [Lua](https://marketplace.visualstudio.com/items?itemName=sumneko.lua) extension for easier server scripting
- Make a github account and push your changes to a new fork of this repository, update this readme to discribe your server and share it
- Follow a port forwarding guide for your router to allow others to access you server, then post it on the discord in #servers
- Consider running the server in a container with docker if you want to autorun the server on startup as a background process
