DATE    = $(shell date +"%F")

all:

docs:
	(cd doc; make html)
	(cd doc/html; zip -r ../selexe.html.zip *.html objects.inv searchindex.js _static/* )
	echo
	echo "Sphinx documentation has been created in doc/html/index.html"
	echo "Use doc/selexe.html.zip for uploading the docs to pypi"

clean:
	find . -name '*.pyc' -exec rm '{}' \;
	find . -name '*~'    -exec rm '{}' \;
	find . -name '*.bak' -exec rm '{}' \;
	find . -name '*.log' -exec rm '{}' \;
	find . -name '.coverage' -exec rm '{}' \;
	rm -rf build dist *.egg-info MANIFEST.in

upload: docs
	# This will upload the current version to pypi. Credentials are stored in ~/.pypirc
	python setup.py register
	python setup.py sdist upload
	echo  "For uploading the latest documentation login to pypi and upload doc/selexe.html.zip"


backup: clean _backup

_backup: 
	DIR=`pwd`; bDIR=`basename $$DIR`; cd ..; \
	tar -czf $${bDIR}_$(DATE).tgz -X $$bDIR/TAR_EXCLUDELIST $$bDIR ; \
	echo "Created backup ../$${bDIR}_$(DATE).tgz"


test:
	(cd  selexe; py.test)

coverage:
	pyTest=`which py.test` ; \
	(cd selexe; coverage run $${pyTest} ; coverage report -m)

