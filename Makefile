all:

include Makefile.env

up:
	git push -u origin master
e:
	vim Makefile.env
m:
	vim Makefile
gs:
	git status
gc:
	git commit -a
	

gd :
	git diff

ga :
	git add .

rg:regen
regen:
	[ -f config.toml ] && make regenX || make regenX -C scripts.Hugo 
regenX:
	rm -fr public/*
	cp ../CNAME public/
	[ -f public/CNAME ] || ( echo ; echo "why no CNAME ? exit" ; echo ; exit 32 )
	hugo

s : server
server:
	hugo server

# hddps://themes.gohugo.io/
# hddps://gohugo.io/themes/

