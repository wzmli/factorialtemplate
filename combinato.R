rm(list=ls())
require(data.table)

# receive forbidden, all files to source for combinations
## for development
# args <- strsplit(
#  "forbidden.csv fitting/A.fct fitting/B.fct observation/A.fct observation/B.fct observation/C.fct observation/noisy.fct observation/proportional.fct process/A.fct process/B.fct process/discrete.fct process/hybrid.fct",
#  split=" "
# )[[1]]
args <- commandArgs(trailingOnly = T)
illegal <- fread(args[1])
dimensions <- names(illegal)

# assert: args[-1] = dir/file == dimension_name/factorvalue[.ext]
src <- data.table(
  dimension = gsub("^(.+)/.+$",      "\\1", args[-1]), # grab the path
  value     = gsub("^.+/(.+)\\..+$", "\\1", args[-1])  # grab the filename, drop extension
)[, list(values = list(factor(value))), keyby=dimension ]

if (sum(dimensions %in% unique(src$dimension)) != length(dimensions))
  stop(sprintf(
    "dimensions in %s header (%s) do not match those provided as source files (%s)",
    args[1],
    paste(dimensions, collapse=", "),
    paste(unique(src$dimension), collapse=", ")
  ))

# extract each dimension, expand grid on those dimensions
ref <- with(src,{
  names(values) <- dimension
  data.table(do.call(expand.grid, values))
})

# build a filter from forbidden.csv rows
filt <- parse(text=paste(apply(illegal, 1, function(row) {
  relevant <- row != "*"
  sprintf("!(%s)",paste(sprintf("(%s == '%s')", names(row)[relevant], row[relevant]), collapse = " & "))
}), collapse = " & "))

# build a statement to combine dimensions
ev <- parse(text=sprintf("paste(%s, sep='_', collapse = ' ')",paste(dimensions,collapse = ", ")))

# filter full factorial down to keepers, then output the remaining combinations to stdout
cat(ref[eval(filt)][,eval(ev)])