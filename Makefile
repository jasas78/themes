
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
	pwd
	nice -n 17 git push -u origin master
e:
	vim Makefile.env
m:
	vim Makefile
gs:
	nice -n 17 git status
gc:
	nice -n 17 git commit -a

gcXmmm:=$(shell (LC_ALL=C date +"%Y%m%d_%H%M%p" ; cat /etc/timezone )|tr "/\r\n-" _)
gcX:
	nice -n 17 git commit -m $(gcXmmm)
	

gd :
	nice -n 17 git diff

ga :
	nice -n 17 git add .
rp:
	@echo nice -n 17 git repack -a -d --window-memory 10m --max-pack-size 20m
	nice -n 17 git config pack.windowMemory 10m
	nice -n 17 git config pack.packSizeLimit 20m




define help_textHU

	um    -> update_makefile  : git pull  && cat Makefile --- ../Makefile 
	rg    -> regen            : regen all hugo
	rgt   -> regenTestVersion : regen all hugo use test version of hugo
	s     -> server           : run hugo   server to test local
	s2    -> server2          : run python server to test local 33221
	s3    -> server3          : run python server to test local 33223
	s5    -> server5          : run python server to test local 33225
	vh    -> hugo_version     : show hugo version
	gus   -> git_up_dusum     : ga gc  up ; du -sh .git ; sync
	gusX  -> git_up_dusumX    : ga gcX up ; du -sh .git ; sync
	gusXt -> gusX_for_theme   : 
	X     -> um rg gusX   
	rvs   -> regen_vh_s2      : regen hugo_version server2
	v1    -> vim test file 01 for hugo
	v2    -> vim test file 02 for hugo
	v3    -> vim test file 03 for hugo
	m3u   -> gen the m3u
	byauthor   -> gen the byauthor
	wav   -> deal with 22.wav

endef

#    mc01 -> myCodeCopy01   : update all the my html shortcodes

testHugo1:=$(strip $(firstword $(wildcard scripts.Hugo/config.toml)))
testHugo2:=$(strip $(firstword $(wildcard config.toml)))
testHugo3:=$(strip $(firstword $(wildcard hugo-theme-docdock/theme.toml)))

$(if $(testHugo1),$(eval UseHugoOnTop:=1),\
	$(if $(testHugo2),$(eval UseHugoUnderScript:=1),\
	$(if $(testHugo3),$(eval UseInTheme:=1),$(error "not_fit_dir"))\
	))


#pythonVersion:=$(shell python --version |awk '{printf $$2}'|awk -F. '{print $$1}')
pythonVersion3exist:=$(shell which python3)
ifeq (,$(pythonVersion3exist))
pythonVersion:=2
pyBin:=python2
else
pythonVersion:=3
pyBin:=python3
endif

############################################### UseHugoOnTop  start
############################################### UseHugoOnTop  start
############################################### UseHugoOnTop  start
ifdef    UseHugoOnTop
$(info using    UseHugoOnTop)

v1 :
	vim `ls scripts.Hugo/layouts/shortcodes/my*.html | head -n 1`
v2 :
	vim `ls scripts.Hugo/layouts/shortcodes/my*.html | head -n 2|tail -n 1`
v3 :
	vim `ls scripts.Hugo/layouts/shortcodes/my*.html | head -n 3|tail -n 1`

rgX:
	cd scripts.Hugo/content/ && . ../1.txt
	cd scripts.Hugo/content/ && . ../3.txt
	make rg

regenBaseCheck:
	@[ -f scripts.Hugo/config.toml ] || ( echo "why_no_33 file <scripts.Hugo/config.toml> exist ?" ; exit 33 )
	[ -d scripts.Hugo/themes ] || rsync -a ../themes/  scripts.Hugo/themes/
	@[ -d scripts.Hugo/themes ] || ( echo "why_no_34 dir <scripts.Hugo/themes> exist ?" ; exit 34 )
	@[ -f scripts.Hugo/themes/hugo-theme-docdock/theme.toml ] || ( echo \
	     "why_no_36 file <scripts.Hugo/themes/hugo-theme-docdock/theme.toml> exist ?" ; exit 36 )
	(test -f disable_themes_pull && (echo;echo disable_themes_pull;echo;echo))|| ( cd scripts.Hugo/themes/ && git pull )
	@[ -d docs ] || mkdir docs
	@[ -L public ] || ln -s docs/ public
	@[ -L scripts.Hugo/public ] || ln -s ../public/ scripts.Hugo/
	rm -fr public/*
	rm -fr scripts.Hugo/resources/_gen/*
	cp CNAME public/
	@[ -f public/CNAME ] || ( echo "why_no_38 file <public/CNAME> exist ?" ; exit 38 )

rmXML := rm -f docs/sitemap.xml docs/images/favicons/browserconfig.xml docs/resources/images/favicons/browserconfig.xml `find docs/ -name index.xml`
updateMakefile :=  [ ! -f scripts.Hugo/Makefile -o ! -f scripts.Hugo/themes/Makefile ] || \
	( cat scripts.Hugo/themes/Makefile > scripts.Hugo/Makefile )

rgt:regenTestVersion
regenTestVersion: regenBaseCheck
	cd scripts.Hugo/ && nice -n 17 hugo.testing         && hugo.testing version
	$(rmXML)
	$(updateMakefile)


rgp : regen_pure 
regen_pure : regenBaseCheck
	cd scripts.Hugo/ && nice -n 17 hugo       && hugo version
	$(rmXML)
	$(updateMakefile)

um update_makefile :
	(cd scripts.Hugo/themes/ && git pull  && cat Makefile > ../Makefile )

rg:regen
regen: byauthor wav m3u sed01 regen_pure

s : server
server:
	@[ -f scripts.Hugo/config.toml ] || ( echo "why_no_41 file <scripts.Hugo/config.toml> exist ?" ; exit 41 )
	cd scripts.Hugo/ && nice -n 17 hugo server --disableFastRender

# hddps://themes.gohugo.io/
# hddps://gohugo.io/themes/

vh : hugo_version   
hugo_version   :
	echo && echo && hugo version && echo && echo

rvs  : regen_vh_s2    
regen_vh_s2    : regen hugo_version server2

pyHttp2:=SimpleHTTPServer
pyHttp3:=http.server
pyHttP:=$(pyHttp$(pythonVersion))
s2: server2
server2:
	[ -f scripts.Hugo/config.toml ] || ( echo "why_no_51 file <scripts.Hugo/config.toml> exist ?" ; exit 51 )
	cd public/ && $(pyBin) -m $(pyHttP) 33221

s3: server3
server3:
	[ -f scripts.Hugo/config.toml ] || ( echo "why_no_51 file <scripts.Hugo/config.toml> exist ?" ; exit 51 )
	cd public/ && $(pyBin) -m $(pyHttP) 33223

s5: server5
server5:
	[ -f scripts.Hugo/config.toml ] || ( echo "why_no_51 file <scripts.Hugo/config.toml> exist ?" ; exit 51 )
	cd public/ && $(pyBin) -m $(pyHttP) 33225

m3u  :
#	m3u8_gen_01.sh https://`cat CNAME`/blog     docs/all.m3u8                                 scripts.Hugo/content/blog
#	m3u8_gen_01.sh https://`cat CNAME`/blog     scripts.Hugo/content/all.m3u8                 scripts.Hugo/content/blog
#	m3u8_gen_01.sh https://`cat CNAME`/blog     scripts.Hugo/content/hot/all.m3u8             scripts.Hugo/content/blog
#	mkdir -p scripts.Hugo/content/hot/endothers/
#	m3u8_gen_01.sh https://`cat CNAME`/blog     scripts.Hugo/content/hot/endothers/all.m3u8   scripts.Hugo/content/blog
	m3u8_gen_01.sh https://`cat CNAME`/blog     scripts.Hugo/content/all.m3u8                 scripts.Hugo/content/blog

byauthor  :
	genHugoAuthor.sh

wav:
	wav_gen_22_wav_list.sh    https://`cat CNAME`/blog     scripts.Hugo/content/all.m3u8      scripts.Hugo/content/blog
	[ $$(find content/ -name 22.wav |wc -l) -eq 0 ] \
		&& echo "22.wav check ok" \
		|| ( echo \
		&& ls -l `find content/ -name 22.wav` \
		&& echo \
		&& echo "check why does 22.wav exist ?" \
		&& echo "nice -n 19 ffmpeg -i " \
		&& echo "                        -vn -ac 1  22.wav" \
		&& echo \
		&& exit 78 \
		)

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

rg rgt regen     s2 server2     s3 server3     s5 server5     s server m3u wav rgX gcX v1 v2 v3 :
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

define myCodeTP02
myCodehtml_list02 += $1
myCodehtml_list03 += $2
myCodehtml_list04 += $3/$2
$3/$2 : $1/$2
	cat $1/$2 > $3/$2 


endef

define myCodeTP01
$$(eval  aa2=$$(shell dirname $1))
$$(eval  aa3=$$(shell basename $1))
$$(eval $$(call myCodeTP02,$$(aa2),$$(aa3),hugo-theme-w3css-basic/layouts/shortcodes))

endef

### find -type d -name shortcodes |grep /layouts/
myCodehtml_list01:=$(shell ls hugo-theme-docdock/layouts/shortcodes/my*.html 2>/dev/null)
$(eval $(foreach aa1,$(myCodehtml_list01),$(call myCodeTP01,$(aa1))))

#mc01 : myCodeCopy01
##mc01 : myCodeCopy02 

gus:  git_up_dusum 
gusX: git_up_dusumX

X : um rg gusX   

gusXt gusX_for_theme : scripts.Hugo/themes/Makefile    
	make -C scripts.Hugo/themes/    gusX 
git_up_dusum  : ga gc  up 
	du -sh .git 
	pwd
	sync
git_up_dusumX : ga gcX up 
	du -sh .git 
	sync

myCodeCopy01:$(myCodehtml_list04)

myCodeCopy02:
	@echo "1<$(myCodehtml_list01)>"
	@echo "2<$(myCodehtml_list02)>"
	@echo "3<$(myCodehtml_list03)>"
	@echo "4<$(myCodehtml_list04)>"

all:
	@echo "$${help_text9}"

export sed01XXX11:=\
	{{< my2m3uexist "music.xspf"        "blue"   "red"    " V单曲 " >}} \
	{{< my2m3uforce "/all.xspf"         "green"  "black"  " V全部 " >}} \
	{{< my2m3uforce "/hot/helpxspf/"    "blue"   "red"    " 播放器 " >}} \
	{{< mybr2 >}} \
	{{< my2m3uforce "/hot/endothers/"   "green"  "blue"   " 目录 " >}} \
	{{< my2m3uexist "music.m3u8"        "blue"   "red"    " M1 " >}} \
	{{< my2m3uforce "/all.m3u8"         "green"  "black"  " M2 " >}} \

export sed01XXX12:=\
	{{< my2buttoncopy2clip "music.xspf"        "blue"   "red"    " 单曲 "  "复制 VLC 播放器使用的链接：单曲" >}} \
	{{< my2buttoncopy2clip "/all.xspf"         "green"  "black"  " 全部 "  "复制 VLC 播放器使用的链接：全部" >}} \
	{{< my2buttoncopy2clip "music.m3u8"        "blue"   "red"    " M3U  "    "复制 M3U 播放器使用的链接：单曲" >}} \
	{{< mybr2 >}} \
	{{< my2buttoncopy2clip ""                  "green"  "black"  " 本页 "    "复制 本页的网址 " >}} \
	{{< my2buttoncopy2clip "/"                 "black"  "red"    " 主站 "    "复制 主站的网址 " >}} \
	{{< mybr2 >}} \
	{{< my2buttongoto      "/hot/endothers/"   "blue"   "red"    " 月份"   "转到月份总目录" >}} \
	{{< my2buttongoto      "/hot/alltags/"     "green"  "blue"   " 列表"   "转到文章总列表" >}} \
	{{< my2buttongoto      "/hot/helpxspf/"    "green"  "blue"   " 播放器" "如何使用 VLC 播放器或者 IPTV 播放器的教程" >}} \

sed01XXX21:={{< my2m3uexist "music.xspf"
sed01XXX22:={{< my2buttoncopy2clip "music.xspf"

#sedFIND01:=find content/blog/ -name "*.md" -printf "%T@  %p\n"|sort -n -r |grep -v '/end0.\\.md'

sed00:
	for aa1 in `find scripts.Hugo/content/blog/ -name "*.md" |grep -v "end0.\\.md" ` ; do \
		\
		sed -i -e '$$a \\n'  $${aa1} ; \
		\
		done

sed01:
	for aa1 in `find scripts.Hugo/content/blog/ -name "*.md" |grep -v "end0.\\.md" ` ; do \
		\
		sed -i \
		-e '/$(sed01XXX21)/d' \
		-e '/$(sed01XXX22)/d' \
		$${aa1} ; \
		\
		sed -i -e '$$a $(sed01XXX12)'  $${aa1} ; \
		\
		done

