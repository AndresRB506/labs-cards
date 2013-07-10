EAGLE_CMD := open -W -n /Applications/EAGLE-6.4.0/EAGLE.app --args
docs := $(patsubst src/%.html,build/%.pdf,$(wildcard src/*.html))
SCH := $(shell mktemp -u image.png)

all: $(docs)

build/%.pdf: src/%.html src/images/%.png src/static/main.css
		wkpdf --source $< --output $@ --print-background yes --paper custom:276x376 --no-paginate

src/images/%.png: schematics/%.sch
		$(EAGLE_CMD) -C "export image /tmp/$(SCH) 600; quit;" "$(CURDIR)/$<"
		convert /tmp/$(SCH) -threshold 75% $@
		rm /tmp/$(SCH)
