# receive forbidden, all files to source for combinations

require(data.table)

## for development
# args <- strsplit(
#  "forbidden.csv fitting/A.fct fitting/B.fct observation/A.fct observation/B.fct observation/C.fct observation/noisy.fct observation/proportional.fct process/A.fct process/B.fct process/discrete.fct process/hybrid.fct",
#  split=" "
# )[[1]]
args <- commandArgs(trailingOnly = T)

illegal <- fread(args[1])

# assert: args[-1] = dir/file == dimension_name/factorvalue[.ext]
src <- data.table(
  dimension = gsub("^(.+)/.+$",      "\\1", args[-1]), # grab the path
  value     = gsub("^.+/(.+)\\..+$", "\\1", args[-1])  # grab the filename, drop extension
)[, list(values = list(factor(value))), keyby=dimension ]



# extract each dimension, expand grid on those dimensions
ref <- with(src,{
  names(values) <- dimension
  data.table(do.call(expand.grid, values))
})

i <- 0
fn <- dim(illegal)[1]
while(i < fn) {
  i <- i+1
  filt <- as.list(illegal[i])
  ## TODO rewrite as an eval that uses `names` vice hard coding
  ref <- ref[!(
    grepl(filt$fitting, fitting) &
    grepl(filt$observation, observation) &
    grepl(filt$process, process)
  )]
}

## TODO rewrite as an eval that uses `names` vice hard coding
cat(ref[,paste(fitting, observation, process, sep="_", collapse = " ")])
