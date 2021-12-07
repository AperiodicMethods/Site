# Makefile for the AperiodicMethods site


##########################################################################
## REQUIREMENTS
#
# This file requires `jupyter-book` for building the site.
#

##########################################################################
## VARIABLES

BOOK			= apmethods
GITHUB-ORG		= https://github.com/AperiodicMethods
CONTENT-REPO		= aperiodicmethods
SITE-LOC		= aperiodicmethods.github.io

##########################################################################
## CLONING MATERIALS

# Clone all materials
clone:
	@make clone-notebooks

# Clone the notebooks
clone-notebooks:

	# Copy tutorial materials
	@git clone --depth 1 $(GITHUB-ORG)/$(CONTENT-REPO) $(BOOK)/notebooks
	@mv $(BOOK)/temp/notebooks $(BOOK)/notebooks/
	@rm -rf $(BOOK)/temp/

##########################################################################
## BUILDING SITE


# Clear out the copied repositories
clear:

	# Clear cloned materials
	rm -rf $(BOOK)/notebooks

# Build the textbook
build:
	jupyter-book build $(BOOK)/


##########################################################################
## DEPLOYING SITE


# Deploy the website
deploy:

	# Create the textbook
	make build

	# Clone the website deployment repository
	rm -rf $(BOOK)/_build/deploy/
	git clone --depth 1 $(GITHUB-ORG)/$(SITE-LOC) $(BOOK)/_build/deploy/

	# A .nojekyll file tells Github pages to bypass Jekyll processing
	touch $(BOOK)/_build/deploy/.nojekyll

	# Copy site into the gh-pages branch folder, then push to Github to deploy
	cd $(BOOK)/_build/ && \
	cp -r html/ deploy && \
	cd deploy && \
	git add * && \
	git add .nojekyll && \
	git commit -a -m 'deploy site' && \
	git push
