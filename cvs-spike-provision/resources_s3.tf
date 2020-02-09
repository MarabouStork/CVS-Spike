resource "aws_s3_bucket" "staging_test_results" {
    bucket = var.staging_bucket_test_results
    acl    = "private"

    lifecycle {
        prevent_destroy = true
    }
}

resource "aws_s3_bucket_public_access_block" "staging_test_results_public_block" {
  bucket = aws_s3_bucket.staging_test_results.id

  block_public_acls   = true
  block_public_policy = true
}
