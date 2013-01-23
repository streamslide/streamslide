import boto
import os

AWS_ACCESS_KEY_ID = os.environ.get('AWS_ACCESS_KEY_ID')
AWS_SECRET_ACCESS_KEY = os.environ.get('AWS_SECRET_ACCESS_KEY')
AWS_S3_BUCKET_NAME = os.environ.get('AWS_S3_BUCKET_NAME')

s3 = boto.connect_s3(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
bucket = s3.get_bucket(AWS_S3_BUCKET_NAME)

def set_cors():
    cors = boto.s3.cors.CORSConfiguration()
    cors.add_rule(allowed_method=['GET', 'PUT', 'POST', 'HEAD', 'DELETE'],
            allowed_origin='*', allowed_header='*',
            max_age_seconds=3000, expose_header='x-amz-server-side-encryption')

    bucket.set_cors(cors)

def get_cors():
    return bucket.get_cors_xml()

def main():
    return set_cors()

if __name__ == "__main__":
    main()
