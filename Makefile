
$(if $(strip $(shell [ 'root' = $${USER} ] && echo 1 )),$(info you should NOT run by root)$(error xxx))


all:

include Makefile.env

up:
	nice -n 19 git push -u origin master
e:
	vim Makefile.env
m:
	vim Makefile
gs:
	nice -n 19 git status
gc:
	nice -n 19 git commit -a
	

gd :
	nice -n 19 git diff

ga :
	nice -n 19 git add .
rp:
	@echo nice -n 19 git repack -a -d --window-memory 10m --max-pack-size 20m
	nice -n 19 git config pack.windowMemory 10m
	nice -n 19 git config pack.packSizeLimit 20m


existHugo:=$(strip $(firstword $(wildcard scripts.Hugo/config.toml config.toml)))

$(if $(existHugo),$(eval UseHugo:=1),$(eval UseTree:=1))

############################################### UseHugo  start
############################################### UseHugo  start
############################################### UseHugo  start
ifdef    UseHugo

rg:regen
regen:
	[ -f scripts.Hugo/config.toml ] && make regenX -C scripts.Hugo || make regenX 
#	[ -d themes ] || echo "you should run : git clone https://marstool@github.com/marstool/themes.git"
#	[ -d themes ] || git clone https://marstool@github.com/marstool/themes.git
regenX:
	[ -d themes ] || rsync -a ../themes/  themes/
	cd themes && git pull
	[ -L public ] || ln -s ../public/
	rm -fr public/*
	rm -fr resources/_gen/*
	cp ../CNAME public/
	[ -f public/CNAME ] || ( echo ; echo "why no CNAME ? exit" ; echo ; exit 32 )
	nice -n 19 hugo

s : server
server:
	[ -d themes ] || echo "you should run : git clone https://marstool@github.com/marstool/themes.git"
	[ -f scripts.Hugo/config.toml ] && make serverX -C scripts.Hugo || make serverX 
serverX:
	nice -n 19 hugo server --disableFastRender
#	nice -n 19 hugo server

# hddps://themes.gohugo.io/
# hddps://gohugo.io/themes/

s2: server2
server2:
	[ -f scripts.Hugo/config.toml ] && make server2X -C scripts.Hugo || make server2X 
server2X:
	cd public/ && python -m SimpleHTTPServer 33221


define help_text

	rg -> regen   : regen all hugo
	s  -> server  : run hugo   server to test local
	s2 -> server2 : run python server to test local

endef
export help_text


endif
############################################### UseHugo  end
############################################### UseHugo  end
############################################### UseHugo  end


############################################### UseTree  start
############################################### UseTree  start
############################################### UseTree  start
ifdef UseTree

gen00:
	tree -H '.' -L 1 --noreport --charset utf-8 > index.html

tg: treeGen
treeGen:
	cd public/ && rm -f CNAME index.html
	[   -f index.html ] || (cd public/ && tree -H '.' --noreport --charset utf-8 > index.html)
	[ ! -f index.html ] || (cat index.html > public/index.html)
	make sed01
	cp CNAME public/
	cat config > .git/config
	@echo
	@grep jjj123 CNAME 
	@echo
	@grep marstool .git/config
	@echo
	diff config .git/config
	@echo

dynW01:=<h2><a href="https://www.jjj123.com">安全上网教程 www.jjj123.com</a></h2>
dynW02:=<h3><a href="https://mp3s.jjj123.com">时事见闻 mp3s.jjj123.com</a></h3>
sed01:
	sed -i \
		-e '/meta name=/d' \
		-e '/ by Steve Baker and Thomas Moore/d' \
		-e '/ by Francesc Rocher/d' \
		-e '/ by Florian Sesser/d' \
		-e '/ by Kyosuke Tokoro/d' \
		-e 's;<h1>Directory Tree</h1><p>;$(dynW01);g' \
		-e 's;<title>Directory Tree</title>;<title>https://www.jjj123.com</title>;g' \
		-e 's;<a href="\.">\.</a><br>;$(dynW02);g' \
		public/index.html

s3: server3
server3:
	[ -d public ] || (                pwd && python -m SimpleHTTPServer 33221 )
	[ ! -d public ] || ( cd public && pwd && python -m SimpleHTTPServer 33221 )

define help_text

	tg --> treeGen -> gen the index.html by tree
	s3 -> server3 : run python server to test local

endef
export help_text

endif
############################################### UseTree  end
############################################### UseTree  end
############################################### UseTree  end

all:
	@echo "$${help_text}"
