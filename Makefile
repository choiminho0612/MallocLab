# ==== Git Helper Makefile (Windows/cmd OK) ====
ifeq ($(OS),Windows_NT)
SHELL := cmd.exe
.SHELLFLAGS := /C
endif


# 기본 설정
REMOTE ?= origin
URL    ?= https://github.com/choiminho0612/MallocLab
MSG    ?= Update

# url 인자 없으면 URL 변수 사용
RA_URL := $(if $(url),$(url),$(URL))
# 커밋 메시지도 m 인자 우선, 없으면 MSG 기본값
CMSG   := $(if $(m),$(m),$(MSG))

.PHONY: help s i ra rr a c ip p ap pull sync

help:
	@echo make help              - git guide
	@echo make s                 - git status (short)
	@echo make i                 - git init (init local repo)
	@echo make ra url=URL        - set/add remote origin
	@echo make rr                - remove remote origin
	@echo make a                 - git add -A
	@echo make c m="msg"         - git commit -m "msg"  [default: $(MSG)]
	@echo make ip                - first push: main branch with -u
	@echo make p                 - push current branch (HEAD)
	@echo make ap m="msg"        - add + commit + push
	@echo make pull              - pull --rebase (HEAD)
	@echo make sync              - pull --rebase + push

s:
	git status -sb

i:
	git init

# 이미 remote 있으면 set-url, 없으면 add (cmd에서 || 사용)
ra:
	git remote set-url $(REMOTE) "$(RA_URL)" || git remote add $(REMOTE) "$(RA_URL)"
	git remote -v

rr:
	git remote remove $(REMOTE)

a:
	git add -A

c:
	git commit -m "$(CMSG)"

# 최초 업스트림 설정
ip:
	git branch -M main
	git push -u $(REMOTE) main

# 현재 체크아웃된 브랜치(HEAD) 그대로 푸시/풀
p:
	git push $(REMOTE) HEAD

pull:
	git pull --rebase $(REMOTE) HEAD

ap: a c p

sync: pull p
