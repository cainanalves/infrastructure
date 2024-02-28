provider "aws" {
    region = "us-east-1"
}

variable "bucket_name" {
    type = string
}

resource "aws_s3_bucket" "static_site_bucket_teste" {
    bucket = "static-site-${var.bucket_name}"

    website {
        index_document = "index.html"
        error_document = "404.html"
    }

    tags = {
        Name = "Static Site Bucket"
        Environment = "Production"
    }
}

resource "aws_s3_bucket_public_access_block" "static_site_bucket_teste" {
    bucket = aws_s3_bucket.static_site_bucket_teste.id

    block_public_acls = false
    block_public_policy = false
    ignore_public_acls = false
    restrict_public_buckets = false
}

resource "aws_s3_bucket_ownership_controls" "static_site_bucket_teste" {
    bucket = aws_s3_bucket.static_site_bucket_teste.id
    rule {
        object_ownership = "BucketOwnerPreferred"
    }

}

resource "aws_s3_bucket_acl" "static_site_bucket_teste" {
  depends_on = [ 
    aws_s3_bucket_public_access_block.static_site_bucket_teste,
    aws_s3_bucket_ownership_controls.static_site_bucket_teste
   ]

   bucket = aws_s3_bucket.static_site_bucket_teste.id
   acl = "public-read"
}