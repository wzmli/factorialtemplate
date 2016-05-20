## Hooks

testt: alljags

target: allruns.pbs

# some convenient definitions

EMPTY :=
SPACE := $(EMPTY) $(EMPTY)
BUG := bug
NIM := nimR
ROUT := Rout

FITDIR := fitting
OBSDIR := observation
PRODIR := process
SEEDDIR := seeds

DIMDIRS := $(FITDIR) $(PRODIR) $(OBSDIR) $(SEEDDIR)

FITS := $(wildcard $(FITDIR)/*)
PROS := $(wildcard $(PRODIR)/*)
OBSS := $(wildcard $(OBSDIR)/*)
SEEDS := $(wildcard $(SEEDDIR)/*)

R := /usr/bin/env Rscript

combinations.txt: combinato.R forbidden.csv $(FITS) $(PROS) $(OBSS) $(SEEDS)
	$(R) $^ > $@

SAMPDIR := samples
SAMPS := $(wildcard $(SAMPDIR)/*)
SAMPN := $(words $(SAMPS))

jags.model-filename = $(subst $(SPACE),_,$(basename $(notdir $(1) $(2) $(3)))).$(BUG)

nim.model-filename = $(subst $(SPACE),_,$(basename $(notdir $(1) $(2) $(3)))).$(NIM)

# using filtered factorial
define jags.model-template-filtered
$(1).$(BUG): bugstemp.R $(addsuffix .R,$(join $(DIMDIRS),$(addprefix /,$(subst _, ,$(1)))))
	$(R) $$^ > $$@

JAGSALLMODELS += $(1).$(BUG)

endef

define nim.model-template-filtered
$(1).$(NIM): nimbletemp.R $(addsuffix .R,$(join $(DIMDIRS),$(addprefix /,$(subst _, ,$(1)))))
	$(R) $$^ > $$@

NIMALLMODELS += $(1).$(NIM)

endef

# run
define jags.fit
jags.$(1).$(ROUT): jags.R dat.R $(1).$(BUG)
	$(R) $$^ > $$@


JAGSALLMODELS += jags.$(1).$(ROUT)

endef

define nim.fit
nim.$(1).$(ROUT): nimble.R dat.R $(1).$(NIM)
	 R CMD BATCH nimble.R $$^ >$$@

NIMALLMODELS += nim.$(1).$(ROUT)

endef

$(foreach combo,$(shell cat combinations.txt),$(eval $(call jags.model-template-filtered,$(combo))))
$(foreach combo,$(shell cat combinations.txt),$(eval $(call jags.fit,$(combo))))

$(foreach combo,$(shell cat combinations.txt),$(eval $(call nim.model-template-filtered,$(combo))))
## $(foreach combo,$(shell cat combinations.txt),$(eval $(call nim.fit,$(combo))))

alljags: combinations.txt $(JAGSALLMODELS)
allnim: combinations.txt $(NIMALLMODELS)

nim.%.Rout: dat.R %.nimR nimble.R
	$(run-R)

nimdis: allnim
	bash run_dis_nim

MODSN := $(words $(JAGSALLMODELS))

clean-models:
	rm *.$(BUG) *.$(ROUT) *.$(NIM) *.RDS *.Rlog *.wrapR.r *.rout



#### ML does not know how pbs works

# force user to setup some local environmental variables
# used as defaults in pbs scripts
.myhpc:
	./setup.sh $@

# now that we have all the rules, we want a supercomputer script
# that will invoke them all as part of an torque array job (assuming qsub infrastructure)
# we need to generate (1) that script and (2) the series of inputs/invocations
# that depend on $PBS_ARRAYID

# one approach: have a pbs run for each component in the factorial design.
# upside: can have tailored resource requirements for runs
# downside: ...tailored resource requirements for runs (as in, user has to provide all of
# them individually).  however, we can just take a "defaults" approach and use make arguments to
# override them.
# another advantage to this approach: $PBS_ARRAYID is used w/ the sample #s
# this is really useful for looking up jobs: you have jobname which
# tells you factor combination + array id within job telling you sample id

# convention: use lowercase make variables to correspond to values we expect to sometimes
# override

# probably way to generous for single factor, single sample calc
walltime := 12:00:00
# assumes a single factor & sample is not multinode
nodes := 1
# ...but may support multithread
cores := 4
# not a big mem footprint, but not small either
pmem := 4gb
# depends on what simulators are
mods := module load gcc/5.2.0 R/3.2.2;

run-with-pbs = (export WALLTIME="$(walltime)"; export NODES="$(nodes)"; export CORES="$(cores)"; export PMEM="$(pmem)"; export MODS="$(mods)"; $(1))

run_%.pbs: write-run-one-pbs.sh %.$(BUG) .myhpc $(SAMPS)
	$(call run-with-pbs,./$< $@ $* $(SAMPN))

allfactorspbs: $(subst $(BUG),pbs,$(addprefix run_,$(ALLMODELS)))

clean-pbs:
	rm *.pbs

results:
	mkdir $@

# stub for alt pbs approach

define param-insert
@echo $(1) >> $(2)

endef

pbs-params.csv: allmodels $(SAMPS)
	$(foreach model,$(basename $(notdir $(ALLMODELS))),\
	$(foreach sample,$(basename $(notdir $(SAMPS))),\
	$(call param-insert,make result/$(model).$(sample).out,$@)\
	))

allruns.pbs: write-run-all-pbs.sh pbs-params.csv
	$(call run-with-pbs,./$^ $@ allruns $$(($(SAMPN)*$(MODSN))))

.SECONDEXPANSION:

# now we need to map our factorial model combinations to outputs
# here, we just need to match to (1) model combination and (2) sample
# so we can use secondary expansion to parse %

results/%.out: $$(basename $$*).$(BUG) samples/$$(subst .,,$$(suffix $$*)).in | results
	@echo $@ depends on $^



####################DSMS###########################

Sources += Makefile stuff.mk
include stuff.mk
-include $(ms)/git.def

Sources += $(wildcard *.R)

-include $(ms)/git.mk
-include $(ms)/visual.mk
-include $(ms)/linux.mk
-include $(ms)/wrapR.mk
-include rmd.mk

