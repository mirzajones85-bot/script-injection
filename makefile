APP=secdim.lab.go
.SILENT:
.PHONY: all build test securitytest clean header
all: build

check:
ifeq (,$(shell which act))
        $(error "[!] act not found.")
endif

test: check header
	echo -e "\033[1;33m\n[i] Running Github workflow locally\033[0m\n"
	act push \
		&& echo -e "\033[1;32m\n[i] Well done! Github workflow ran successfully\033[0m\n"\
		|| echo -e "\033[1;31m\n[!] Oh, no! Github workflow has bug(s)! Try again\033[0m\n"

securitytest: header build
	echo -e "\033[1;33m\n[i] Push your code to SecDim repository\033[0m\n"
	echo -e "\033[1;33m\n[i] Security tests would run against your code\033[0m\n"


run: test

clean:
	docker image rm ${APP}
	docker system prune
	docker image prune -f

define HEADER

   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%%%%%%%              %%%%%%%%%%%%
   %%%%%%%%%%%                  ,%%%%%%%%%%
   %%%%%%%%%%         *%%%%*    %%%%%%%%%%%
   %%%%%%%%%%        %%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%%%%             *%%%%%%%%%%%%%%%
   %%%%%%%%%%%%%               .%%%%%%%%%%%
   %%%%%%%%%%%%%%%%%%            %%%%%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%        %%%%%%%%%
   %%%%%%%%%%      .%%%%.         %%%%%%%%%
   %%%%%%%%%%                   .%%%%%%%%%%
   %%%%%%%%%%%%,             ,%%%%%%%%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
              play.secdim.com
endef
export HEADER

header:
	@echo -e "\033[1;35m$$HEADER\033[0m"

push: test
	echo -e "\033[1;33m\n[i] Build, test and push to SecDim\033[0m\n"
	git add . && git commit -m 'security fix' && git push
	echo -e "\033[1;32m\n[i] Done! Checkout the challenge commits page\033[0m\n"

status:
	curl "https://play.secdim.com/api/v1/status/$(shell git rev-parse HEAD)/username/$(word 3, $(subst /, ,$(shell git remote get-url origin)))"
