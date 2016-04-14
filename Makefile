# so we have one directory per factorial dimension
# could, BUT DO NOT WANT TO, have `make` dynamically figure these out
# do not want b/c: transparency

FITDIR := fitting
OBSDIR := observation
PRODIR := process

FITS := $(wildcard $(FITDIR)/*)
OBSS := $(wildcard $(OBSDIR)/*)
PROS := $(wildcard $(PRODIR)/*)

EMPTY :=
SPACE := $(EMPTY) $(EMPTY)

define model-template
factor_$(subst $(SPACE),_,$(basename $(notdir $(1) $(2) $(3)))).model: $(1) $(2) $(3)
	@echo $$@ depends on $$^

endef

$(foreach fit,$(FITS),\
 $(foreach obs,$(OBSS),\
  $(foreach pro,$(PROS),\
   $(eval $(call model-template,$(fit),$(obs),$(pro)))\
)))