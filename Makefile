SHELL=/bin/bash -o pipefail


example.log:	src/example.py
	./pystanenv.sh python3 $^ | tee $@


clean_cache:
	rm -rf httpstan_cache/models
.PHONY: clean_cache
