DOCSET_NAME = GNU_Autoconf

DOCSET_DIR    = $(DOCSET_NAME).docset
CONTENTS_DIR  = $(DOCSET_DIR)/Contents
RESOURCES_DIR = $(CONTENTS_DIR)/Resources
DOCUMENTS_DIR = $(RESOURCES_DIR)/Documents

INFO_PLIST_FILE = $(CONTENTS_DIR)/Info.plist
INDEX_FILE      = $(RESOURCES_DIR)/docSet.dsidx
ICON_FILE       = $(DOCSET_DIR)/icon.png
ARCHIVE_FILE    = $(DOCSET_NAME).tgz

MANUAL_URL  = https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/autoconf-2.71/autoconf.html_node.tar.gz
MANUAL_FILE = tmp/autoconf.html_node.tar.gz

DOCSET = $(INFO_PLIST_FILE) $(INDEX_FILE) $(ICON_FILE)

all: $(DOCSET)

archive: $(ARCHIVE_FILE)

clean:
	rm -rf $(DOCSET_DIR) $(ARCHIVE_FILE)

tmp:
	mkdir -p $@

$(ARCHIVE_FILE): $(DOCSET)
	tar --exclude='.DS_Store' -czf $@ $(DOCSET_DIR)

$(MANUAL_FILE): tmp
	curl -o $@ $(MANUAL_URL)

$(DOCSET_DIR):
	mkdir -p $@

$(CONTENTS_DIR): $(DOCSET_DIR)
	mkdir -p $@

$(RESOURCES_DIR): $(CONTENTS_DIR)
	mkdir -p $@

$(DOCUMENTS_DIR): $(RESOURCES_DIR) $(MANUAL_FILE)
	mkdir -p $@
	tar -x -z -f $(MANUAL_FILE) -C $@

$(INFO_PLIST_FILE): src/Info.plist $(CONTENTS_DIR)
	cp src/Info.plist $@

$(INDEX_FILE): src/index.sh $(DOCUMENTS_DIR)
	rm -f $@
	src/index.sh $@ $(DOCUMENTS_DIR)/*.html
	src/index.sh -i "Entry" $@ $(DOCUMENTS_DIR)/Concept-Index.html
	src/index.sh -i "Macro" $@ $(DOCUMENTS_DIR)/M4-Macro-Index.html
	src/index.sh -i "Macro" $@ $(DOCUMENTS_DIR)/Autoconf-Macro-Index.html
	src/index.sh -i "Macro" $@ $(DOCUMENTS_DIR)/Autotest-Macro-Index.html
	src/index.sh -i "Variable" $@ $(DOCUMENTS_DIR)/Cache-Variable-Index.html
	src/index.sh -i "Variable" $@ $(DOCUMENTS_DIR)/Output-Variable-Index.html
	src/index.sh -i "Function" $@ $(DOCUMENTS_DIR)/Program-_0026-Function-Index.html
	src/index.sh -i "Entry" $@ $(DOCUMENTS_DIR)/Preprocessor-Symbol-Index.html
	src/index.sh -i "Variable" $@ $(DOCUMENTS_DIR)/Environment-Variable-Index.html

$(ICON_FILE): src/icon.png $(DOCSET_DIR)
	cp src/icon.png $@
