EAGLE_CMD := open -W -n /Applications/EAGLE-6.4.0/EAGLE.app --args
BUILDDIR := build
docs := $(patsubst src/%.html,$(BUILDDIR)/%.pdf,$(wildcard src/*.html))
SCH := $(shell mktemp -u image.png)


all: $(BUILDDIR) $(docs)

build/%.pdf: src/%.html src/images/%.png src/static/main.css
		wkhtmltopdf --javascript-delay 500 --page-width 276mm $< $@

cards.pdf: $(BUILDDIR)/*.pdf $(docs)
		pdfunite $(BUILDDIR)/*.pdf cards.pdf

src/images/%.png: schematics/%.sch
		$(EAGLE_CMD) -C "export image /tmp/$(SCH) 600; quit;" "$(CURDIR)/$<"
		convert /tmp/$(SCH) -threshold 75% $@
		rm /tmp/$(SCH)

$(BUILDDIR):
	mkdir -p $(BUILDDIR)
