# Coder-Kit
This is Coder-Kit a small lightweight nvim's powerful coding tool that can too be in your mobile , laptop , non x86_64 , non arm/aarch devices and even in the powerful tool named termux. Hope You use it peacefully and to prove yourself. If you feel that it it broken then ask Chatgpt it will tell you what is going wrong and how can you balance. 

# Why this nvim init ?

This is a powerful nvim coder confug as it even covers arm/arch asm and even x86 asm , however since this config was actually created with my Iqoo z6 Lite 5g which is a arm/aarch based mobile you will face problems only with arm asm however don't worry. 

# What can give error ?

*Deleting too Many things or heavy modifications without the help of Ai or Professionals can make you frustrate and delete nvim*

This is a powerful config but the asm both arm and x86 have non working lsps yeah you Heard right!
Pyright for Python works well but requires that venv to be activated and this block as you project root with this file named "pyrightconfig.jason" , at the core of your Python folder. 

#Python pyright Config ----->
``` Json
{
  "venvPath": "/home/you/Python",
  "venv": "venv",
  "pythonVersion": "3.12",
  "include": ["src", "tests"],
  "reportMissingImports": true,
  "reportMissingTypeStubs": false
}
```
# Java Script , Css and Html Lsps 
Uses tc-lc or something same named lsp hemce you have to work accordingly 
and also if you are going to add any lsp in this config then make sure to add only after the Javascript , Html & Css lsps and before the lua's comment in which I wrote something similar like "--- Lsps end here"

# C & Cpp 
Use as it is Clang and Clangd or clang tidy is much better for c and cpp here is the compilation command for bash and zsh 
```bash/zsh
clang++ filename.cpp -o filename
./filename
```

# x86-64, the X64 works well with qemu-user-x86-64 
Sorry no Lsp for X86-64 as no widely supported chad lsp like clang!
For x86-64 it is better to use nasm as the config is accroding to that
Here is the compilation command for non x86_64 machines 
```bash/zsh
nasm -f elf64 filename.nasm -o filename.o
ld.lld -m elf-x86_64 filename.o -o filename
qemu-user-x86-64 ./filename 
```
*If using x86 device look for chat gpt or some trusted sources for compilation*

# Themes
Theme used is github default white and default black you can even switch to a black or white theme depending on you need by just typing esc + : , and then ---->

```nvim
:lua ToggleGithubTheme()
```
Remeber it is like on off switch with no arguments.

# A lot of things to do take a look & modify accrodingly after reading this!

# History 
1st Edit and Post -- September , 17th , 2025 , Ekadshi , IST ~7:26pm Device Iqoo Z6 Lite 5g!
