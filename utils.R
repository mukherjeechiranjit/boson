# Utility functions for RBOSON
# Chiranjit Mukherjee


## Start: S3 utils ##

#' Create a folder in S3
#' 
#' @param s3path path to an S3 directory
S3CreateFolder = function (s3path) {
  # create a tmplorary file
  file.create('0')
  
  # make an 'aws s3 cp' call
  system2('aws', c('s3', 'cp', '0', s3path))
  
  # delete the temporary file locally and on S3
  file.remove('0')
  # system2('aws', c('s3', 'rm', paste0(s3path, '0')))
}
# S3CreateFolder(s3path = 's3://boson-base/rboson-test/')


#' List all files in an S3 directory
#' 
#' @param s3path path to an S3 directory
#' @param sanitize boolean, whether to exclude the temporary file '0' from returns; default is TRUE
#' @return a list of files at the s3path as a character vector
S3ListFiles = function (s3path, sanitize = TRUE) {
	# make an 'aws s3 ls' call and capture stdout
  out = system2('aws', c('s3', 'ls', s3path), stdout = TRUE)
	
  # parse filenames out of the output
  splits = strsplit(out, "\\s+")
  files = c()
  for (s in splits) {
    files = c(files, tail(s, 1))
  }
  
  if (sanitize) {
    return (setdiff(files, '0'))
  } else {
    return (files)
  }
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


#' Delete a floder in S3 with all of its contents
#' 
#' @param s3path path to an S3 directory
S3DeleteFolder = function (s3path) {
  # delete all files in s3path
  S3DeleteFiles(s3path, S3ListFiles(s3path, sanitize = FALSE))
}
# S3DeleteFolder(s3path = 's3://boson-base/rboson-test/')


#' Create a bucket in S3
#' 
#' @param bucket name of the bucket to be created
S3CreateBucket = function (bucket) {
  # make an 'aws s3 mb' call
  out = system2('aws', c('s3', 'mb', bucket), stdout = TRUE)
  
  if (grepl('make_bucket', out)) {
    return ('success')
  } else {
    return('error')
  }
}
# print(S3CreateBucket(bucket = 's3://cm-tmp-3186876'))

#' Delete a bucket in S3
#' 
#' @param bucket name of the bucket to be deleted
S3DeleteBucket = function (bucket) {
  # make an 'aws s3 rb' call
  out = system2('aws', c('s3', 'rb', bucket))
  
  if (grepl('remove_bucket', out)) {
    return ('success')
  } else {
    return('error')
  }
}
# print(S3DeleteBucket(bucket = 's3://cm-tmp-3186876'))

# unit tests

require(testthat)

test_that("S3 utils checks:", {
  bucket = paste0('rboson-', floor(as.numeric(Sys.time())))
  
  # create a bucket
  expect_output(S3CreateBucket(bucket = bucket), 'success')
  
  # delete the bucket
  expect_output(S3DeleteBucket(bucket = bucket), 'success')
})





## End: S3 utils ##