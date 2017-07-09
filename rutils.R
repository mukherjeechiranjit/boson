# Utility functions for RBOSON
# Chiranjit Mukherjee


## Start: S3 utils ##

#' List all files in an S3 directory
#' 
#' @param s3path path to an S3 directory
#' @return  
S3ListFiles = function (s3path) {
	# make an 'aws s3 ls' call and capture stdout
  out = system2('aws', c('s3', 'ls', s3path), stdout = TRUE)
	
  # parse filenames out of the output
  splits = strsplit(out, "\\s+")
  files = c()
  for (s in splits) {
    files = c(files, tail(s, 1))
  }
  
	return (setdiff(files, '0'))
}
# print(S3ListFiles(s3path = 's3://boson-base/rboson-test/'))


#' Copy files to / from S3
#' 
#' @param source path to source directory (local / S3)
#' @param destination path to destination diectory (local / S3)
#' @param files list of files to be copied as a character vector
S3CopyFiles = function (source = NULL, destination, files) {
  # append source path
  if (! is.null(source)) {
    files = paste0(source, files)
  }
  
  for (f in files) {
    # make an 'aws s3 cp' call
    system2('aws', c('s3', 'cp', f, destination))
  }
}
# S3CopyFiles(destination = 's3://boson-base/rboson-test/', files = c('hello_world.R', 'rutils.R'))
# S3CopyFiles(
#   source = 's3://boson-base/rboson-test/',
#   destination = '/Users/cmukherjee/Google_Drive/boson/tmp/',
#   files = c('hello_world.R', 'rutils.R')
# )


#' Delete files from S3
#' 
#' @param s3path path to an S3 directory
#' @param files list of files to be deleetd as a character vector
S3DeleteFiles = function (s3path, files) {
  files = paste0(s3path, files)
  for (f in files) {
    # make an 'aws s3 rm' call
    system2('aws', c('s3', 'rm', f))
  }
}
# S3DeleteFiles(s3path = 's3://boson-base/rboson-test/', files = c('hello_world.R', 'rutils.R'))

## End: S3 utils ##