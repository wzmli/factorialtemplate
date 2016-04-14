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

# our factorial combination inputs are each a file
# and the file names include each dimension value as part of the name
# i.e., 'factor_DIM1VAL_DIM2VAL_DIM3VAL.model'
# we make that naming easy to use (and enforce) by defining a function for it

model-filename = factor_$(subst $(SPACE),_,$(basename $(notdir $(1) $(2) $(3)))).model

# finally we want to dynamically generate a rule for each target
# it would be nice to use pattern rules, but matching multiple patterns
# doesn't work nicely.  However, the pattern for the rules is simple, so we
# define a function for writing a rule from inputs
# Having a variable that is the complete model list is convenient,
# so we can append to such a variable every time a new rule is written

define model-template
$(call model-filename,$(1),$(2),$(3)): $(1) $(2) $(3)
	@echo $$@ depends on $$^

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

# now that we have all the rules, we want a supercomputer script
# that will invoke them all as part of an torque array job (assuming qsub infrastructure)
# we need to generate (1) that script and (2) the series of inputs that depend on $PBS_ARRAYID

run.pbs pbs-params.csv: $(FITS) $(OBSS) $(PROS)
	@echo write param input file from script
	@echo write pbs file from script