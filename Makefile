## Hooks

target: allfactorspbs

# some convenient definitions

EMPTY :=
SPACE := $(EMPTY) $(EMPTY)

# so we have one directory per factorial dimension
# could, BUT DO NOT WANT TO, have `make` dynamically figure these out
# do not want b/c: transparency

FITDIR := fitting
OBSDIR := observation
PRODIR := process

# we want to dependencies related to all of the points in those dimensions
# and we track those points with a file for each

FITS := $(wildcard $(FITDIR)/*)
OBSS := $(wildcard $(OBSDIR)/*)
PROS := $(wildcard $(PRODIR)/*)

# we also have various samples we want to consider in each of these
# factorial dimensions.  these are another dimension in some sense,
# but since we use them in a fundamentally different way we will
# treat them seperately

SAMPDIR := samples
SAMPS := $(wildcard $(SAMPDIR)/*)
SAMPN := $(words $(SAMPS))

# our factorial combination inputs are each a file
# and the file names include each dimension value as part of the name
# i.e., 'DIM1VAL_DIM2VAL_DIM3VAL.model'
# we make that naming easy to use (and enforce) by defining a function for it

model-filename = $(subst $(SPACE),_,$(basename $(notdir $(1) $(2) $(3)))).model

# finally we want to dynamically generate a rule for each target
# it would be nice to use pattern rules, but matching multiple patterns
# doesn't work nicely.  However, the pattern for the rules is simple, so we
# define a function for writing a rule from inputs
# Having a variable that is the complete model list is convenient,
# so we can append to such a variable every time a new rule is written

define model-template
$(call model-filename,$(1),$(2),$(3)): $(1) $(2) $(3)
	@echo change to do something with $$^
	touch $$@

ALLMODELS += $(call model-filename,$(1),$(2),$(3))

endef

# now we apply our rule generation template to all combinations
# of all factor dimensions: nested foreach loops, one level
# for each dimension, and an innermost invocation of template
# to each of loop variables
# n.b., it's important to do $(eval $(call ...))
# $(call ...) creates the appropriate string
# but $(eval ...) takes that string and includes it in the make definitions
# WARNING: THIS NEST LOOP IS PARSED EVERYTIME `make` IS INVOKED
# so for a factorial design that includes many, large dimensions, should prefer to
# have these rules built once (and rebuilt only when necessary), rather than dynamically
# for each `make ...` call.  Clever way to do that might be to have
# a to-be-included .mk file which is (re)built based on
# directory contents, then always included?

$(foreach fit,$(FITS),\
 $(foreach obs,$(OBSS),\
  $(foreach pro,$(PROS),\
   $(eval $(call model-template,$(fit),$(obs),$(pro)))\
)))

allmodels: $(ALLMODELS)

clean-models:
	rm *.model

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

run_%.pbs: write-run-one-pbs.sh %.model .myhpc $(SAMPS)
	(export WALLTIME="$(walltime)"; export NODES="$(nodes)"; export CORES="$(cores)"; export PMEM="$(pmem)"; export MODS="$(mods)"; ./$< $@ $* $(SAMPN))

allfactorspbs: $(subst model,pbs,$(subst factor,run,$(ALLMODELS)))

clean-pbs:
	rm *.pbs

results:
	mkdir $@

# stub for alt pbs approach

define param-insert
@echo $(1) >> $(2)

endef

pbs-params.csv: $(ALLMODELS) $(SAMPS)
	$(foreach model,$(basename $(notdir $(ALLMODELS))),\
	$(foreach sample,$(basename $(notdir $(SAMPS))),\
	$(call param-insert,make result/$(model).$(sample).out,$@)\
	))

.SECONDEXPANSION:

# now we need to map our factorial model combinations to outputs
# here, we just need to match to (1) model combination and (2) sample
# so we can use secondary expansion to parse %

results/%.out: $$(basename $$*).model samples/$$(subst .,,$$(suffix $$*)).in | results
	@echo $@ depends on $^
