
$(if $(strip $(shell [ 'root' = $${USER} ] && echo 1 )),$(info you should NOT run by root)$(error xxx))


all:

include Makefile.env

git :
	git config --global core.fileMode 				false
	git config --global core.editor 				vim
	git config --global user.email 					"you@example.com"
	git config --global user.name 					"Your Name"
	git config --global pack.windowMemory           "32m"
	git config --global pack.packSizeLimit          "33m"
	git config --global pack.deltaCacheSize         "34m"
	git config --global pack.threads                "1"
	git config --global core.packedGitLimit         "35m"
	git config --global core.packedGitWindowSize    "36m"
	git config --global http.postbuffer             "5m"
	git repack -a -d --window-memory 10m --max-pack-size 50m

gitX:
	swapoff                /swapfile || echo
	#dd if=/dev/zero     of=/swapfile bs=1024 count=1048576
	dd if=/dev/zero     of=/swapfile bs=1024 count=4194304
	chmod 600              /swapfile
	mkswap                 /swapfile
	swapon                 /swapfile

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




define help_textHU

	rg -> regen   : regen all hugo
	s  -> server  : run hugo   server to test local
	s2 -> server2 : run python server to test local

endef


testHugo1:=$(strip $(firstword $(wildcard scripts.Hugo/config.toml)))
testHugo2:=$(strip $(firstword $(wildcard config.toml)))
testHugo3:=$(strip $(firstword $(wildcard hugo-theme-docdock/theme.toml)))

$(if $(testHugo1),$(eval UseHugoOnTop:=1),\
	$(if $(testHugo2),$(eval UseHugoUnderScript:=1),\
	$(if $(testHugo3),$(eval UseInTheme:=1),$(error "not_fit_dir"))\
	))

############################################### UseHugoOnTop  start
############################################### UseHugoOnTop  start
############################################### UseHugoOnTop  start
ifdef    UseHugoOnTop
$(info using    UseHugoOnTop)

rg:regen
regen:
	@[ -f scripts.Hugo/config.toml ] || ( echo "why_no_33 file <scripts.Hugo/config.toml> exist ?" ; exit 33 )
	[ -d scripts.Hugo/themes ] || rsync -a ../themes/  scripts.Hugo/themes/
	@[ -d scripts.Hugo/themes ] || ( echo "why_no_34 dir <scripts.Hugo/themes> exist ?" ; exit 34 )
	@[ -f scripts.Hugo/themes/hugo-theme-docdock/theme.toml ] || ( echo \
	     "why_no_36 file <scripts.Hugo/themes/hugo-theme-docdock/theme.toml> exist ?" ; exit 36 )
	cd scripts.Hugo/themes/ && git pull
	@[ -d docs ] || mkdir docs
	@[ -L public ] || ln -s docs/ public
	@[ -L scripts.Hugo/public ] || ln -s ../public/ scripts.Hugo/
	rm -fr public/*
	rm -fr scripts.Hugo/resources/_gen/*
	cp CNAME public/
	@[ -f public/CNAME ] || ( echo "why_no_38 file <public/CNAME> exist ?" ; exit 38 )
	cd scripts.Hugo/ && nice -n 19 hugo

s : server
server:
	@[ -f scripts.Hugo/config.toml ] || ( echo "why_no_41 file <scripts.Hugo/config.toml> exist ?" ; exit 41 )
	cd scripts.Hugo/ && nice -n 19 hugo server --disableFastRender

# hddps://themes.gohugo.io/
# hddps://gohugo.io/themes/

s2: server2
server2:
	[ -f scripts.Hugo/config.toml ] || ( echo "why_no_51 file <scripts.Hugo/config.toml> exist ?" ; exit 51 )
	cd public/ && python -m SimpleHTTPServer 33221


export help_textHU
endif
############################################### UseHugoOnTop  end
############################################### UseHugoOnTop  end
############################################### UseHugoOnTop  end

############################################### UseHugoUnderScript begin
############################################### UseHugoUnderScript begin
############################################### UseHugoUnderScript begin
ifdef    UseHugoUnderScript
$(info using    UseHugoUnderScript )

rg regen     s2 server2     s server :
	cd .. && make $@


export help_textHU
endif
############################################### UseHugoUnderScript end
############################################### UseHugoUnderScript end
############################################### UseHugoUnderScript end

############################################### UseInTheme begin
############################################### UseInTheme begin
############################################### UseInTheme begin
ifdef    UseInTheme
$(info using    UseInTheme )

endif
############################################### UseInTheme end
############################################### UseInTheme end
############################################### UseInTheme end



help_text9=$(if $(help_textTV),$(help_textTV),$(if $(help_textHU),$(help_textHU),$(help_textINDEX)))
export help_text9

all:
	@echo "$${help_text9}"
