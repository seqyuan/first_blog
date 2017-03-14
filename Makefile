	
help:
		@echo 'Makefile for git push                                                     '
		@echo '                                                                          '
		@echo 'Usage:                                                                    '
		@echo '   make push                           push change                        '
		@echo '                                                                          '
	
push:
	git add -A
	git commit -m "change"
	git push