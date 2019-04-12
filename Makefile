
prereqs:
	/bin/bash --login
	rvm user gemsets
	rvm use system

qt:
	gem install qtbindings

gems:
	gem install chroma
	gem install colorize
	gem install sqlite3
	gem install test-unit
