SHELL := /bin/sh

pkg_name := onat-management-system
user := oms
app_dir := /opt/oms
conf_dir := /etc/oms
app_files :=	version.yml \
		app \
		bin \
		config \
		db \
		lib \
		public \
		config.ru \
		Gemfile \
		Gemfile.lock \
		Rakefile \
		vendor \
		.bundle

exclude_files := config/database.yml \
		 config/puma.rb \
		 config/secrets.yml \
		 config/storage.yml

config_files := database.yml \
		puma.rb \
		secrets.yml \
		storage.yml

export DEBFULLNAME ?= ONAT Admin
export DEBMAIL ?= admin@onat.edu.ua
debian_host_release != lsb_release -sc
commit = $(shell git rev-parse HEAD)
gems := $(CURDIR)/vendor/bundler
bundle_bin := $(gems)/bin/bundle
bundler_gems := $(CURDIR)/vendor/bundle
export GEM_PATH := $(gems):$(bundler_gems)

# debuild vars
debuild_env := http_proxy https_proxy SSH_AUTH_SOCK TRAVIS*
debuild_flags := $(foreach e,$(debuild_env),-e '$e') $(if $(findstring yes,$(lintian)),--lintian,--no-lintian)

### Rules ###
.PHONY: all
all: assets


version.yml: debian/changelog
	$(info >>> Create version file)
	@echo "version: " $(shell dpkg-parsechangelog -S Version) > $@
	@echo "commit: " $(commit) >> $@
	cat $@


debian/changelog:
	$(info >>> Generating changelog)
	changelog-gen -p "$(pkg_name)" -d "$(debian_host_release)" -A "s/_/~/g" "s/-rc/~rc/"


.PHONY: bundler
bundler:
	$(info >>> Install bundler)
	gem install --no-doc --install-dir $(gems) bundler


.PHONY: gems
gems:	bundler
	$(info >>> Install/Update gems)
	$(bundle_bin) install --jobs=4 --deployment --without development test


.PHONY: assets
assets:	gems
	$(info >>> Precompiling assets)
	@cp -vb config/database.ci.yml config/database.yml
	@cp -vb config/secrets.yml.distr config/secrets.yml
	$(bundle_bin) exec rake assets:precompile RAILS_ENV=production
	@rm -fv config/database.yml
	@rm -fv config/secrets.yml


.PHONY: install
install: $(app_files)
	$(info >>> Install app files)
	@install -vd $(DESTDIR)$(app_dir) $(DESTDIR)$(app_dir)/tmp $(DESTDIR)$(conf_dir)
	tar -c --no-auto-compress $(addprefix --exclude , $(exclude_files)) $^ | tar -x -C $(DESTDIR)$(app_dir)
	@install -v -m0644 -D debian/$(pkg_name).rsyslog $(DESTDIR)/etc/rsyslog.d/$(pkg_name).conf
	@install -v -m0644 config/puma.rb.distr $(DESTDIR)$(conf_dir)/puma.rb
	$(foreach f,$(config_files),ln -sTv $(conf_dir)/$f $(DESTDIR)$(app_dir)/config/$f;)


.PHONY: clean
clean:
	$(info >>> Cleaning)
	rm -rf $(gems)
	rm -rf $(bundler_gems)
	rm -rf .bundle
	rm -rf tmp
	rm -rf public/assets


.PHONY: clean-all
clean-all:
	-@debian/rules clean
	@rm -fv version.yml
	@rm -fv debian/changelog


.PHONY: package
package: debian/changelog
	$(info >>> Building package)
	debuild $(debuild_flags) -uc -us -b



